package storage

import (
	"crypto/cipher"
	"crypto/sha256"
	"log"
	"strconv"

	"gorm.io/driver/postgres"
	"gorm.io/gorm"
	"gorm.io/gorm/logger"

	"github.com/domai-tb/campus_vote/pkg/core"
)

type CampusVoteStorage struct {
	conf   DBConfig
	cipher cipher.AEAD
}

func New(conf DBConfig, password string) *CampusVoteStorage {
	// init crypto
	cipher := createCipher(sha256.Sum256([]byte(password)))

	// init database
	db := getCockroachDB(conf.GetConnectionString())
	db.AutoMigrate(&EncVoter{})
	db.AutoMigrate(&EncVoterStatus{})

	return &CampusVoteStorage{conf: conf, cipher: cipher}
}

func (cvdb *CampusVoteStorage) CreateNewVoter(voter Voter) error {
	db := getCockroachDB(cvdb.conf.GetConnectionString())

	if _, err := cvdb.GetVoterByStudentId(voter.StudentId); err == nil {
		return core.StudentAllreadyExistsError()
	}

	envVoter := cvdb.encryptVoter(voter)
	db.Create(envVoter)

	return nil
}

func (cvdb *CampusVoteStorage) GetVoterByStudentId(id int) (Voter, error) {
	db := getCockroachDB(cvdb.conf.GetConnectionString())

	var tmp EncVoter
	db.Where("student_id = ?", cvdb.encryptWithoutNonce(strconv.Itoa(id))).First(&tmp)

	result, _ := cvdb.decryptVoter(tmp)

	if result.StudentId == id {
		return result, nil
	}

	return Voter{}, core.StudentNotFoundError()
}

func getCockroachDB(connectionString string) *gorm.DB {
	db, err := gorm.Open(postgres.Open(connectionString), &gorm.Config{
		Logger: logger.Default.LogMode(logger.Silent), // disable SQL logging
	})
	if err != nil {
		log.Fatal(err)
	}

	return db
}

func (cvdb *CampusVoteStorage) SetVoterAsVoted(v Voter) error {
	db := getCockroachDB(cvdb.conf.GetConnectionString())

	status := cvdb.CheckVoterStatus(v)

	if status {
		return core.StudentAllreadyVotedError()
	}

	db.Create(cvdb.encryptVoterStatus(v))
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
	db := getCockroachDB(cvdb.conf.GetConnectionString())

	var tmp EncVoterStatus
	db.Where("student_id = ?", cvdb.encryptWithoutNonce(strconv.Itoa(v.StudentId))).First(&tmp)

	vstatus, err := cvdb.decryptVoterStatus(tmp)
	if err != nil {
		// voter not in list of voted
		return false
	}

	// should always true
	return vstatus.Status
}

func (cvdb *CampusVoteStorage) CheckVoterStatusByStudentId(id int) bool {
	voter, err := cvdb.GetVoterByStudentId(id)

	if err != nil {
		return false
	}

	return cvdb.CheckVoterStatus(voter)
}
