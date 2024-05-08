package storage

import (
	"crypto/cipher"
	"crypto/sha256"
	"fmt"
	"log"
	"strconv"

	"gorm.io/driver/postgres"
	"gorm.io/gorm"
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
	db.AutoMigrate(&EncVoted{})

	return &CampusVoteStorage{conf: conf, cipher: cipher}
}

func (cvdb *CampusVoteStorage) CreateNewVoter(voter Voter) error {
	db := getCockroachDB(cvdb.conf.GetConnectionString())

	if _, err := cvdb.GetVoterByStudentId(voter.StudentId); err == nil {
		return fmt.Errorf("voter allready in database")
	}

	envVoter := cvdb.EncryptVoter(voter)
	db.Create(envVoter)

	return nil
}

func (cvdb *CampusVoteStorage) GetVoterByStudentId(id int) (Voter, error) {
	db := getCockroachDB(cvdb.conf.GetConnectionString())

	var tmp EncVoter
	db.Where("student_id = ?", cvdb.encryptWithoutNonce(strconv.Itoa(id))).First(&tmp)

	result, _ := cvdb.DecryptVoter(tmp)
	fmt.Printf("Result of search for %d: %v\n", id, result)

	if result.StudentId == id {
		return result, nil
	}

	return Voter{}, fmt.Errorf("could not found voter with id: %d", id)
}

func getCockroachDB(connectionString string) *gorm.DB {
	db, err := gorm.Open(postgres.Open(connectionString), &gorm.Config{})
	if err != nil {
		log.Fatal(err)
	}

	return db
}

func (cvdb *CampusVoteStorage) SetVoterAsVoted(v Voter) {
	db := getCockroachDB(cvdb.conf.GetConnectionString())
	db.Create(cvdb.EncryptVoterStatus(v))
}

func (cvdb *CampusVoteStorage) CheckVoterStatus(v Voter) (bool, error) {
	db := getCockroachDB(cvdb.conf.GetConnectionString())

	var tmp EncVoted
	db.Where("student_id = ?", cvdb.encryptWithoutNonce(strconv.Itoa(v.StudentId))).First(&tmp)

	vstatus, err := cvdb.DecryptVoterStatus(tmp)
	if err != nil {
		return true, fmt.Errorf("failed to decrypt voter status: %w", err)
	}

	return vstatus.Status, nil
}
