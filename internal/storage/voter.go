package storage

import (
	"fmt"
	"strconv"
)

type Voter struct {
	Firstname string
	Lastname string
	StudentId int
	BallotBox string
	Faculity string
	Voted bool
}

type EncVoter struct {
	Firstname []byte
	Lastname []byte
	StudentId []byte
	BallotBox []byte
	Faculity []byte
	Voted []byte 
}

func (cvdb *CampusVoteStorage) EncryptVoter(v Voter) EncVoter {
	return EncVoter{
		Firstname: cvdb.encrypt(v.Firstname),
		Lastname: cvdb.encrypt(v.Lastname),
		StudentId: cvdb.encrypt(strconv.Itoa(v.StudentId)),
		BallotBox: cvdb.encrypt(v.BallotBox),
		Faculity: cvdb.encrypt(v.Faculity),
		Voted: cvdb.encrypt(strconv.FormatBool(v.Voted)),
	}
}

func (cvdb *CampusVoteStorage) DecryptVoter(v EncVoter) (Voter, error) {
	
	strId, err := cvdb.decrypt((v.StudentId))
	if err != nil {
		return Voter{}, fmt.Errorf("failed to decrypt voter: %w", err)
	}

	id, err := strconv.Atoi(strId)
	if err != nil {
		return Voter{}, fmt.Errorf("failed to decode studentId: %w", err)
	}

	strVoted, err := cvdb.decrypt(v.Voted)
	if err != nil {
		return Voter{}, fmt.Errorf("failed to decrypt voter: %w", err)
	}

	voted, err := strconv.ParseBool(strVoted)
	if err != nil {
		return Voter{}, fmt.Errorf("failed to decode voters voting status: %w", err)
	}

	firstname, err := cvdb.decrypt(v.Firstname)
	if err != nil {
		return Voter{}, fmt.Errorf("failed to decrypt voter: %w", err)
	}

	lastname, err := cvdb.decrypt(v.Lastname)
	if err != nil {
		return Voter{}, fmt.Errorf("failed to decrypt voter: %w", err)
	}

	ballotBox, err := cvdb.decrypt(v.BallotBox)
	if err != nil {
		return Voter{}, fmt.Errorf("failed to decrypt voter: %w", err)
	}

	faculity, err := cvdb.decrypt(v.Faculity)
	if err != nil {
		return Voter{}, fmt.Errorf("failed to decrypt voter: %w", err)
	}
	
	return Voter{
		Firstname: firstname,
		Lastname: lastname,
		StudentId: id,
		BallotBox: ballotBox,
		Faculity: faculity,
		Voted: voted,
	}, nil
}