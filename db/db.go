package main

import (
	"fmt"
	"log"

	"gorm.io/driver/postgres"
	"gorm.io/gorm"
)

func getConnectionString(conf CampusVoteDBConfig) string {
	return fmt.Sprintf(
		"postgresql://%s@%s:%d/%s?sslmode=verify-full&sslrootcert=%s&sslcert=%s&sslkey=%s", 
		conf.username, conf.host, conf.port, conf.database, conf.rootCert, conf.clientCert, conf.clientKey,
	)
}

//export createNewVoter
func createNewVoter(conf CampusVoteDBConfig, voter CampusVoteVoter) {
	db, err := gorm.Open(postgres.Open(getConnectionString(conf)), &gorm.Config{})
	if err != nil {
		log.Fatal(err)
	}

	// Migrate the schema 
	db.AutoMigrate(&CampusVoteVoter{})

	// Create new voter
	db.Create(voter)
}

//export enforce_binding
func enforce_binding() {}

func main() {}