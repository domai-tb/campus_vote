package main

import (
	"fmt"

	"github.com/domai-tb/campus_vote/internal/storage"
)

func main() {
	db := storage.New(*storage.DefaultDBConfig(), "1234")

	voter1 := storage.Voter{
		Firstname: "Tim",
		Lastname:  "Barsch",
		StudentId: 10801910718,
		BallotBox: "MC",
		Faculity:  "Informatik",
	}

	voter2 := storage.Voter{
		Firstname: "Patrick",
		Lastname:  "Wallkowiak",
		StudentId: 10801910719,
		BallotBox: "MC",
		Faculity:  "Physik",
	}

	if err := db.CreateNewVoter(voter1); err != nil {
		fmt.Println(err)
	}

	if err := db.CreateNewVoter(voter2); err != nil {
		fmt.Println(err)
	}

	student, err := db.GetVoterByStudentId(10801910718)
	if err == nil {
		db.SetVoterAsVoted(student)
	}

	if err != nil {
		fmt.Println(err)
	}
	fmt.Println("Voter: ", student)

	student, err = db.GetVoterByStudentId(10801910719)
	if err != nil {
		fmt.Println(err)
	}
	fmt.Println("Voter: ", student)

	voter1Status, err := db.CheckVoterStatus(voter1)
	if err != nil {
		fmt.Println(err)
	}
	fmt.Printf("Voter %d status: %v", voter1.StudentId, voter1Status)

	voter2Status, err := db.CheckVoterStatus(voter2)
	if err != nil {
		fmt.Printf("Voter %d status: %v", voter2.StudentId, false)
	} else {
		fmt.Printf("Voter %d status: %v", voter2.StudentId, voter2Status)
	}
}
