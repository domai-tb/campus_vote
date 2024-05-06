package storage

import "fmt"

type DBConfig struct {
	Username string
	Host string 
	Port int
	Database string
	RootCert string
	ClientCert string
	ClientKey string
}

func (conf *DBConfig) GetConnectionString() string {
	return fmt.Sprintf(
		"postgresql://%s@%s:%d/%s?sslmode=verify-full&sslrootcert=%s&sslcert=%s&sslkey=%s", 
		conf.Username, conf.Host, conf.Port, conf.Database, conf.RootCert, conf.ClientCert, conf.ClientKey,
	)
}

func DefaultDBConfig() *DBConfig {
	return &DBConfig{
		Username: "root",
		Host: "127.0.0.1",
		Port: 26257,
		Database: "defaultdb",
		RootCert: "cockroach/certs/ca.crt",
		ClientCert: "cockroach/certs/client.root.crt",
		ClientKey: "cockroach/certs/client.root.key",
	}
}
