package storage

type Voter struct {
	Firstname string
	Lastname string
	StudentId int
	BallotBox string
	Faculity string
}

type EncVoter struct {
	Firstname []byte
	Lastname []byte
	StudentId []byte
	BallotBox []byte
	Faculity []byte
}