package main

import (
	"fmt"

	"github.com/domai-tb/campus_vote/pkg/storage"
)

var LIST_OF_VOTERS = [...]storage.Voter{
	{
		StudentId: 10800000000,
		Firstname: "Olaf",
		Lastname: "Scholz",
		BallotBox: "MC",
		Faculity: "Bundeskanzler",
	},
	{
		StudentId: 10800000001,
		Firstname: "Patrick",
		Lastname: "Walkowiak",
		BallotBox: "MC",
		Faculity: "Physik",
	},
	{
		StudentId: 10800000002,
		Firstname: "Tim",
		Lastname: "Barsch",
		BallotBox: "MC",
		Faculity: "Informatik",
	},
	{
		StudentId: 10800000003,
		Firstname: "Ron",
		Lastname: "Agethen",
		BallotBox: "MC",
		Faculity: "Biologie",
	},
	{
		StudentId: 10800000004,
		Firstname: "Elisabeth",
		Lastname: "Tillbürger",
		BallotBox: "MC",
		Faculity: "Geographie",
	},
	{
		StudentId: 10800000005,
		Firstname: "Hendrik",
		Lastname: "Meinert",
		BallotBox: "MC",
		Faculity: "Physik",
	},
	{
		StudentId: 10800000006,
		Firstname: "Robin",
		Lastname: "Wegener",
		BallotBox: "MC",
		Faculity: "Phylospohie",
	},
}

func main() {
	// Create a new campus vote storage with password "patrick4president"
	electionStorage := storage.New(*storage.DefaultDBConfig(), "patrick4president")

	// Create voter registry
	fmt.Printf("\n === initialize voter registry with students === \n")
	for _, voter := range LIST_OF_VOTERS {
		if err := electionStorage.CreateNewVoter(voter); err != nil {
			fmt.Println(err) // voter allready exists
		}
	}

	// Get voters by student id
	fmt.Printf("\n === get students in voter registry === \n")
	for _, voter := range LIST_OF_VOTERS {
		if student, err := electionStorage.GetVoterByStudentId(voter.StudentId); err != nil {
			fmt.Println(err) // voter not found
		} else {
			fmt.Println(student)
		}
	}

	// Ongoing election...
	for i, voter := range LIST_OF_VOTERS {
		if i%2 == 0 {
			// Ever second student votes!! <3
			electionStorage.SetVoterAsVoted(voter)
		}
	}

	// See who allready voted
	fmt.Printf("\n === election: student already voted? === \n")
	for _, voter := range LIST_OF_VOTERS {
		if electionStorage.CheckVoterStatus(voter) {
			fmt.Printf("%s %s (%d): voted :)\n", voter.Firstname, voter.Lastname, voter.StudentId)
		} else {
			fmt.Printf("%s %s (%d): not voted :(\n", voter.Firstname, voter.Lastname, voter.StudentId)
		}
	}
}