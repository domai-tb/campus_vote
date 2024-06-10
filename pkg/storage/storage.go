package storage

import (
	"crypto/cipher"
	"crypto/sha256"
	"slices"
	"strconv"

	"github.com/domai-tb/campus_vote/pkg/core"
)

type CampusVoteStorage struct {
	conf   CampusVoteConf
	cipher cipher.AEAD
}

func New(conf CampusVoteConf, password string) *CampusVoteStorage {
	// init crypto
	cipher := createCipher(sha256.Sum256([]byte(password)))

	// init database
	db := conf.GetCockroachDB()
	db.AutoMigrate(&EncVoter{}, &EncVoterStatus{}, &ElectionStats{}) // election

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

	envVoter := cvdb.encryptVoter(voter)
	db.Create(envVoter)

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

func (cvdb *CampusVoteStorage) SetVoterAsVoted(v Voter) error {
	db := cvdb.conf.GetCockroachDB()

	status := cvdb.CheckVoterStatus(v)

	if status {
		return core.StudentAllreadyVotedError()
	}

	db.Create(cvdb.encryptVoterStatus(v))
	cvdb.countVote(v.BallotBox)

	return nil
}

func (cvdb *CampusVoteStorage) SetVoterAsVotedByStudentId(id int) error {
	voter, err := cvdb.GetVoterByStudentId(id)

	if err != nil {
		cvErr, ok := err.(*core.CampusVoteError)
		if ok {
			return cvErr
		} else {
			return core.UnexpectedError(err.Error())
		}
	}

	return cvdb.SetVoterAsVoted(voter)
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
