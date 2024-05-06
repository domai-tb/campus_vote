package main

import (
	"fmt"

	"github.com/domai-tb/campus_vote/internal/storage"
)

func main() {
	db := storage.New(*storage.DefaultDBConfig(), "1234")

	voter := storage.Voter{
		Firstname: "Tim",
		Lastname: "Barsch",
		StudentId: 10801910718,
		BallotBox: "MC",
		Faculity: "Informatik",
	}

	db.CreateNewVoter(voter)

	student, err := db.GetVoterByStudentId(10801910718)
	if err != nil {
		fmt.Println(err)
	}

	fmt.Println("Voter: ", student)
}