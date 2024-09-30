package storage

import (
	"crypto/cipher"
	"crypto/sha256"
	"slices"
	"sort"
	"strconv"

	"github.com/domai-tb/campus_vote/pkg/core"
)

type CampusVoteStorage struct {
	conf   core.CampusVoteConf
	cipher cipher.AEAD
}

func New(conf core.CampusVoteConf, password string) *CampusVoteStorage {
	// init crypto
	cipher := createCipher(sha256.Sum256([]byte(password)))

	// init database
	db := conf.GetCockroachDB()
	db.AutoMigrate(&EncVoter{}, &EncVoterStatus{}, &ElectionStats{}, &EncChatMessage{}) // election

	db.Create(newStats(conf.ElectionYear, conf.BallotBoxes))

	return &CampusVoteStorage{conf: conf, cipher: cipher}
}

func (cvdb *CampusVoteStorage) CreateNewVoter(voter Voter) error {
	db := cvdb.conf.GetCockroachDB()

	if _, err := cvdb.GetVoterByStudentId(voter.StudentId); err == nil {
		return core.StudentAllreadyExistsError()
	}

	if !slices.Contains(cvdb.conf.BallotBoxes, voter.BallotBox) {
		return core.BallotBoxDoesNotExistError()
	}

	encVoter := cvdb.encryptVoter(voter)
	db.Create(encVoter)
	cvdb.countVoter()

	return nil
}

func (cvdb *CampusVoteStorage) GetVoterByStudentId(id int) (Voter, error) {
	db := cvdb.conf.GetCockroachDB()

	var tmp EncVoter
	db.Where("student_id = ?", cvdb.encryptWithoutNonce(strconv.Itoa(id))).First(&tmp)

	result, err := cvdb.decryptVoter(tmp)

	if err != nil {
		return Voter{}, core.StudentNotFoundError()
	}

	if result.StudentId == id {
		return result, nil
	}

	return Voter{}, core.StudentNotFoundError()
}

func (cvdb *CampusVoteStorage) SetVoterAsVoted(v Voter, box string, isAfternoon bool) error {
	db := cvdb.conf.GetCockroachDB()

	status := cvdb.CheckVoterStatus(v)

	if status {
		return core.StudentAllreadyVotedError()
	}

	db.Create(cvdb.encryptVoterStatus(v))

	cvdb.countVote(box, isAfternoon)

	return nil
}

func (cvdb *CampusVoteStorage) SetVoterAsVotedByStudentId(id int, box string, isAfternoon bool) error {

	// Check if ballot box exists
	if !BoxInList(box, cvdb.conf.BallotBoxes) {
		return core.BallotBoxDoesNotExistError()
	}

	// Get Voter
	voter, err := cvdb.GetVoterByStudentId(id)

	// Check if voter is allowed to vote
	if err != nil {
		cvErr, ok := err.(*core.CampusVoteError)
		if ok {
			return cvErr
		} else {
			return core.UnexpectedError(err.Error())
		}
	}

	// Set voter as voted
	return cvdb.SetVoterAsVoted(voter, box, isAfternoon)
}

func (cvdb *CampusVoteStorage) CheckVoterStatus(v Voter) bool {
	db := cvdb.conf.GetCockroachDB()

	var tmp EncVoterStatus
	db.Where("student_id = ?", cvdb.encryptWithoutNonce(strconv.Itoa(v.StudentId))).First(&tmp)

	vstatus, err := cvdb.decryptVoterStatus(tmp)
	if err != nil {
		return false
	}

	// should always true
	return vstatus.Status
}

func (cvdb *CampusVoteStorage) CheckVoterStatusByStudentId(id int) (bool, error) {
	voter, err := cvdb.GetVoterByStudentId(id)

	if err != nil {
		cvErr, ok := err.(*core.CampusVoteError)
		if ok {
			return false, cvErr
		} else {
			return false, core.UnexpectedError(err.Error())
		}
	}

	return cvdb.CheckVoterStatus(voter), nil
}

func (cvdb *CampusVoteStorage) SendChatMessage(msg ChatMessage) error {
	db := cvdb.conf.GetCockroachDB()

	encMsg := cvdb.encryptChatMessage(msg)
	db.Create(encMsg)

	return nil
}

func (cvdb *CampusVoteStorage) ReadChat() ([]ChatMessage, error) {
	db := cvdb.conf.GetCockroachDB()

	var encChat []EncChatMessage
	var chat chatMessageSlice // check out chat.go

	// SELECT * FROM ChatMessages;
	result := db.Find(&encChat)

	for _, msg := range encChat {
		decMsg, err := cvdb.decryptChatMessage(msg)
		if err != nil {
			// Append a error message on decryption error
			chat = append(chat, ChatMessage{
				SendAt:        msg.SendAt,
				BallotBoxName: "",
				Message:       "Message failed to decrypt",
			})
		}

		chat = append(chat, decMsg)
	}

	// chatMessageClice implements the required interface
	sort.Sort(chat)

	return chat, result.Error
}

func (cvdb *CampusVoteStorage) GetConfig() core.CampusVoteConf {
	return cvdb.conf
}
