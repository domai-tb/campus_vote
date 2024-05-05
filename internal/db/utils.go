package db

import (
	"crypto/aes"
	"crypto/cipher"
	"log"

	"gorm.io/driver/postgres"
	"gorm.io/gorm"
)

func getCockroachDB(connectionString string) *gorm.DB {
	db, err := gorm.Open(postgres.Open(connectionString), &gorm.Config{})
	if err != nil {
		log.Fatal(err)
	}

	return db
}

func createCipher(key [32]byte) cipher.AEAD {
	// Create a new cipher block from key
	// Key in CampusVoteDB has 32 byte => AES256
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