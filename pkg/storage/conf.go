package storage

import (
	"fmt"
	"log"
	"time"

	"gorm.io/driver/postgres"
	"gorm.io/gorm"
	"gorm.io/gorm/logger"
)

type CampusVoteConf struct {
	Username     string
	Host         string
	Port         int16
	Database     string
	RootCert     string
	ClientCert   string
	ClientKey    string
	ElectionYear int
	BallotBoxes  []string
}

func (conf *CampusVoteConf) GetDBConnectionString() string {
	return fmt.Sprintf(
		"postgresql://%s@%s:%d/%s?sslmode=verify-full&sslrootcert=%s&sslcert=%s&sslkey=%s",
		conf.Username, conf.Host, conf.Port, conf.Database, conf.RootCert, conf.ClientCert, conf.ClientKey,
	)
}

func DefaultCampusVoteConf() *CampusVoteConf {
	return &CampusVoteConf{
		Username:     "root",
		Host:         "127.0.0.1",
		Port:         26257,
		Database:     "defaultdb",
		RootCert:     "cockroach/certs/ca.crt",
		ClientCert:   "cockroach/certs/client.root.crt",
		ClientKey:    "cockroach/certs/client.root.key",
		ElectionYear: time.Now().Year(),
		BallotBoxes:  []string{"IB", "IC", "ID", "NC", "GA", "GB", "GD", "MA"},
	}
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
