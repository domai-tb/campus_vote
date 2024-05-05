package db

import (
	"crypto/cipher"
	"crypto/sha256"
	"fmt"
	"log"
	"strconv"

	"gorm.io/driver/postgres"
	"gorm.io/gorm"

	"github.com/domai-tb/campus_vote/internal/models"
)

type CampusVoteDB struct {
	conf models.DBConfig
	cipher cipher.AEAD
}

func New(conf models.DBConfig, password string) *CampusVoteDB {	
	// init crypto
	cipher := createCipher(sha256.Sum256([]byte(password)))

	// init database
	db := getCockroachDB(conf.GetConnectionString())
	db.AutoMigrate(&models.EncVoter{})

	return &CampusVoteDB{conf: conf, cipher: cipher}
}

func (cvdb *CampusVoteDB) CreateNewVoter(voter models.Voter) error{
	db, err := gorm.Open(postgres.Open(cvdb.conf.GetConnectionString()), &gorm.Config{})
	if err != nil {
		log.Fatal(err)
	}

	_, err = cvdb.GetVoterByStudentId(voter.StudentId)
	if err != nil {
		return fmt.Errorf("voter allready in database")
	}
	
	envVoter := cvdb.EncryptVoter(voter)
	db.Create(envVoter)

	return nil
}

func (cvdb *CampusVoteDB) GetVoterByStudentId(id int) (models.Voter, error) {
	db, err := gorm.Open(postgres.Open(cvdb.conf.GetConnectionString()), &gorm.Config{})
	if err != nil {
		log.Fatal(err)
	}

	var tmp models.EncVoter
	db.Model(&models.EncVoter{StudentId: cvdb.encrypt(strconv.Itoa(id))}).First(&tmp)

	result := cvdb.DecryptVoter(tmp)

	if result.StudentId == id {
		return result, nil
	}

	return models.Voter{}, fmt.Errorf("could not found voter with id: %d", id)
}