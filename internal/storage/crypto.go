package storage

import (
	"crypto/aes"
	"crypto/cipher"
	"crypto/rand"
	"io"
	"strconv"
)

func (cvdb *CampusVoteStorage) encrypt(plaintext string) []byte {

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

func (cvdb *CampusVoteStorage) decrypt(ciphertext []byte) string {
	nonceSize := cvdb.cipher.NonceSize()
	nonce, data := ciphertext[:nonceSize], ciphertext[nonceSize:]

	//Decrypt the data
	plaintext, err := cvdb.cipher.Open(nil, nonce, data, nil)
	if err != nil {
		panic(err.Error())
	}

	return string(plaintext)

}

func (cvdb *CampusVoteStorage) EncryptVoter(v Voter) EncVoter {
	return EncVoter{
		Firstname: cvdb.encrypt(v.Firstname),
		Lastname: cvdb.encrypt(v.Lastname),
		StudentId: cvdb.encrypt(strconv.Itoa(v.StudentId)),
		BallotBox: cvdb.encrypt(v.BallotBox),
		Faculity: cvdb.encrypt(v.Faculity),
	}
}

func (cvdb *CampusVoteStorage) DecryptVoter(v EncVoter) Voter {
	id, err := strconv.Atoi(cvdb.decrypt((v.StudentId)))
	if err != nil {
		panic(err)
	}
	
	return Voter{
		Firstname: cvdb.decrypt(v.Firstname),
		Lastname: cvdb.decrypt(v.Lastname),
		StudentId: id,
		BallotBox: cvdb.decrypt(v.BallotBox),
		Faculity: cvdb.decrypt(v.Faculity),
	}
}

func createCipher(key [32]byte) cipher.AEAD {
	// Create a new cipher block from key
	// Key in CampusVoteStorage has 32 byte => AES256
	block, err := aes.NewCipher(key[:])
	if err != nil {
		panic(err)
	}

	// Create a new AES256 cipher and use GCM 
	cipher, err := cipher.NewGCM(block)
	if err != nil {
		panic(err)
	}

	return cipher
}