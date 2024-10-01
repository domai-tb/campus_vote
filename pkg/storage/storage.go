package storage

import (
	"crypto/cipher"
	"crypto/sha256"
	"fmt"
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

	// Create Ballotbox users and grant rights
	for _, box := range conf.BallotBoxes {
		// password "NULL" enforce certticate-based authentication
		db.Exec(fmt.Sprintf("CREATE USER %s WITH PASSWORD NULL", box))

		// Enable auditing for the table
		db.Exec("ALTER TABLE defaultdb.enc_chat_messages EXPERIMENTAL_AUDIT SET READ WRITE")
		db.Exec("ALTER TABLE defaultdb.enc_voter_statuses EXPERIMENTAL_AUDIT SET READ WRITE")
		db.Exec("ALTER TABLE defaultdb.enc_voters EXPERIMENTAL_AUDIT SET READ WRITE")
		db.Exec("ALTER TABLE defaultdb.election_stats EXPERIMENTAL_AUDIT SET READ WRITE")

		// Chat table
		db.Exec(fmt.Sprintf("GRANT INSERT ON TABLE defaultdb.enc_chat_messages TO %s", box))
		db.Exec(fmt.Sprintf("GRANT SELECT ON TABLE defaultdb.enc_chat_messages TO %s", box))

		// Voter status table
		db.Exec(fmt.Sprintf("GRANT INSERT ON TABLE defaultdb.enc_voter_statuses TO %s", box))
		db.Exec(fmt.Sprintf("GRANT DELETE ON TABLE defaultdb.enc_voter_statuses TO %s", box))
		db.Exec(fmt.Sprintf("GRANT SELECT ON TABLE defaultdb.enc_voter_statuses TO %s", box))

		// Voter registry table
		db.Exec(fmt.Sprintf("GRANT SELECT ON TABLE defaultdb.enc_voters TO %s", box))

		// Stats table
		db.Exec(fmt.Sprintf("GRANT SELECT ON TABLE defaultdb.election_stats TO %s", box))
		db.Exec(fmt.Sprintf("GRANT UPDATE ON TABLE defaultdb.election_stats TO %s", box))
	}

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

func (cvdb *CampusVoteStorage) RegisterVotingStep(v Voter, box string, isAfternoon bool) error {
	db := cvdb.conf.GetCockroachDB()

	status := cvdb.CheckVoterStatus(v)

	switch status {
	case 2:
		// allready votes
		return core.StudentAllreadyVotedError()
	case 1:
		// allready got ballot
		db.Where("student_id = ?", cvdb.encryptWithoutNonce(strconv.Itoa(v.StudentId))).Delete(&EncVoterStatus{})
		db.Create(cvdb.encryptVoterStatus(VoterStatus{StudentId: v.StudentId, Status: 2}))
		cvdb.countVote(box, isAfternoon)
	case 0:
		db.Create(cvdb.encryptVoterStatus(VoterStatus{StudentId: v.StudentId, Status: 1}))
	}

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
	return cvdb.RegisterVotingStep(voter, box, isAfternoon)
}

func (cvdb *CampusVoteStorage) CheckVoterStatus(v Voter) int {
	db := cvdb.conf.GetCockroachDB()

	var tmp EncVoterStatus
	db.Where("student_id = ?", cvdb.encryptWithoutNonce(strconv.Itoa(v.StudentId))).First(&tmp)

	vstatus, err := cvdb.decryptVoterStatus(tmp)
	if err != nil {
		// cannot decrypt because student didn't voted yet
		return 0
	}

	return vstatus.Status
}

func (cvdb *CampusVoteStorage) CheckVoterStatusByStudentId(id int) (int, error) {
	voter, err := cvdb.GetVoterByStudentId(id)

	if err != nil {
		cvErr, ok := err.(*core.CampusVoteError)
		if ok {
			return 0, cvErr
		} else {
			return 0, core.UnexpectedError(err.Error())
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
