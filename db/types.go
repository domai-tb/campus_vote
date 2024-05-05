package main

type CampusVoteDBConfig struct {
	username string
	host string 
	port int
	database string
	rootCert string
	clientCert string
	clientKey string
}

type CampusVoteVoter struct {
	firstname string
	lastname string
	studentId int
	ballotBox string
	faculity string
}