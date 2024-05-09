package storage

import (
	"fmt"
	"strconv"
)

type Voter struct {
	Firstname string
	Lastname  string
	StudentId int
	BallotBox string
	Faculity  string
}

type EncVoter struct {
	Firstname []byte
	Lastname  []byte
	StudentId []byte
	BallotBox []byte
	Faculity  []byte
}

type VoterStatus struct {
	StudentId int
	Status    bool
}

type EncVoterStatus struct {
	StudentId []byte
	Status    []byte
}

func (cvdb *CampusVoteStorage) encryptVoter(v Voter) EncVoter {
	return EncVoter{
		Firstname: cvdb.encrypt(v.Firstname),
		Lastname:  cvdb.encrypt(v.Lastname),
		StudentId: cvdb.encryptWithoutNonce(strconv.Itoa(v.StudentId)),
		BallotBox: cvdb.encrypt(v.BallotBox),
		Faculity:  cvdb.encrypt(v.Faculity),
	}
}

func (cvdb *CampusVoteStorage) decryptVoter(v EncVoter) (Voter, error) {

	strId, err := cvdb.decrypt((v.StudentId))
	if err != nil {
		return Voter{}, fmt.Errorf("failed to decrypt voter: %w", err)
	}

	id, err := strconv.Atoi(strId)
	if err != nil {
		return Voter{}, fmt.Errorf("failed to decode studentId: %w", err)
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
		Lastname:  lastname,
		StudentId: id,
		BallotBox: ballotBox,
		Faculity:  faculity,
	}, nil
}

func (cvdb *CampusVoteStorage) encryptVoterStatus(v Voter) EncVoterStatus {
	return EncVoterStatus{
		StudentId: cvdb.encryptWithoutNonce(strconv.Itoa(v.StudentId)),
		Status:    cvdb.encrypt("true"),
	}
}

func (cvdb *CampusVoteStorage) decryptVoterStatus(v EncVoterStatus) (VoterStatus, error) {

	strId, err := cvdb.decrypt(v.StudentId)
	if err != nil {
		return VoterStatus{}, fmt.Errorf("failed to decrypt voter status: %w", err)
	}

	id, err := strconv.Atoi(strId)
	if err != nil {
		return VoterStatus{}, fmt.Errorf("failed to decode studentId: %w", err)
	}

	strStatus, err := cvdb.decrypt(v.Status)
	if err != nil {
		return VoterStatus{}, fmt.Errorf("failed to decrypt voter status: %w", err)
	}

	status, err := strconv.ParseBool(strStatus)
	if err != nil {
		return VoterStatus{}, fmt.Errorf("failed to decode voter status: %w", err)
	}

	return VoterStatus{
		StudentId: id,
		Status:    status,
	}, nil
}
