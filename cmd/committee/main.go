package main

import (
	"fmt"

	"github.com/domai-tb/campus_vote/internal/db"
	"github.com/domai-tb/campus_vote/internal/models"
)

func main() {
	db := db.New(*models.DefaultDBConfig(), "1234")

	// voter := models.Voter{
	// 	Firstname: "Tim",
	// 	Lastname: "Barsch",
	// 	StudentId: 10801910718,
	// 	BallotBox: "MC",
	// 	Faculity: "Informatik",
	// }

	// db.CreateNewVoter(voter)

	student, err := db.GetVoterByStudentId(10801910718)
	if err != nil {
		fmt.Println(err)
	}

	fmt.Println("Voter: ", student)
}