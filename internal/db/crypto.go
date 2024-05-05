package db

import (
	"crypto/rand"
	"io"
	"strconv"

	"github.com/domai-tb/campus_vote/internal/models"
)

func (cvdb *CampusVoteDB) encrypt(plaintext string) []byte {

	// Create a nonce. Nonce should be from GCM
	nonce := make([]byte, cvdb.cipher.NonceSize())
	if _, err := io.ReadFull(rand.Reader, nonce); err != nil {
		panic(err)
	}

	// Since we don't want to save the nonce somewhere else in this case, 
	// we add it as a prefix to the encrypted data. The first nonce argument 
	// in Seal is the prefix.
	return cvdb.cipher.Seal(nonce, nonce, []byte(plaintext), nil)
}

func (cvdb *CampusVoteDB) decrypt(ciphertext []byte) string {
	nonceSize := cvdb.cipher.NonceSize()
	nonce, data := ciphertext[:nonceSize], ciphertext[nonceSize:]

	//Decrypt the data
	plaintext, err := cvdb.cipher.Open(nil, nonce, data, nil)
	if err != nil {
		panic(err.Error())
	}

	return string(plaintext)

}

func (cvdb *CampusVoteDB) EncryptVoter(v models.Voter) models.EncVoter {
	return models.EncVoter{
		Firstname: cvdb.encrypt(v.Firstname),
		Lastname: cvdb.encrypt(v.Lastname),
		StudentId: cvdb.encrypt(strconv.Itoa(v.StudentId)),
		BallotBox: cvdb.encrypt(v.BallotBox),
		Faculity: cvdb.encrypt(v.Faculity),
	}
}

func (cvdb *CampusVoteDB) DecryptVoter(v models.EncVoter) models.Voter {
	id, err := strconv.Atoi(cvdb.decrypt((v.StudentId)))
	if err != nil {
		panic(err)
	}
	
	return models.Voter{
		Firstname: cvdb.decrypt(v.Firstname),
		Lastname: cvdb.decrypt(v.Lastname),
		StudentId: id,
		BallotBox: cvdb.decrypt(v.BallotBox),
		Faculity: cvdb.decrypt(v.Faculity),
	}
}