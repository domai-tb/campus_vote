package storage

import (
	"crypto/aes"
	"crypto/cipher"
	"crypto/rand"
	"fmt"
	"io"
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

func (cvdb *CampusVoteStorage) decrypt(ciphertext []byte) (string, error) {

	if len(ciphertext) <= cvdb.cipher.NonceSize() {
		return "", fmt.Errorf("malformed ciphertext")
	}

	nonceSize := cvdb.cipher.NonceSize()
	nonce, data := ciphertext[:nonceSize], ciphertext[nonceSize:]

	//Decrypt the data
	plaintext, err := cvdb.cipher.Open(nil, nonce, data, nil)
	if err != nil {
		return "", fmt.Errorf("failed to decrypt ciphertext")
	}

	return string(plaintext), nil

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