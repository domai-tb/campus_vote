package storage

import (
	"crypto/cipher"
	"crypto/sha256"
	"fmt"
	"log"
	"strconv"

	"gorm.io/driver/postgres"
	"gorm.io/gorm"
	"gorm.io/gorm/logger"
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
		return fmt.Errorf("voter allready in database")
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

	return Voter{}, fmt.Errorf("could not found voter with id: %d", id)
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
		return fmt.Errorf("voter %d already voted", v.StudentId)
	}

	db.Create(cvdb.encryptVoterStatus(v))
	return nil
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
