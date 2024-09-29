package main

import (
	"fmt"

	"github.com/domai-tb/campus_vote/pkg/core"
	"github.com/domai-tb/campus_vote/pkg/storage"
)

var LIST_OF_VOTERS = [...]storage.Voter{
	{
		StudentId: 10800000000,
		Firstname: "Olaf",
		Lastname:  "Scholz",
		BallotBox: "MA",
		Faculity:  "Bundeskanzler",
	},
	{
		StudentId: 10800000001,
		Firstname: "Gustav",
		Lastname:  "Braun",
		BallotBox: "NC",
		Faculity:  "Physik",
	},
	{
		StudentId: 10800000002,
		Firstname: "Jens",
		Lastname:  "Mett",
		BallotBox: "MA",
		Faculity:  "Informatik",
	},
	{
		StudentId: 10800000003,
		Firstname: "Ronald",
		Lastname:  "McDonald",
		BallotBox: "NC",
		Faculity:  "Biologie",
	},
	{
		StudentId: 10800000004,
		Firstname: "Tilli",
		Lastname:  "Billi",
		BallotBox: "IB",
		Faculity:  "Geographie",
	},
	{
		StudentId: 10800000005,
		Firstname: "Rolando",
		Lastname:  "Michelanchilo",
		BallotBox: "GD",
		Faculity:  "Jura",
	},
	{
		StudentId: 10800000006,
		Firstname: "Robin",
		Lastname:  "Grumelberg",
		BallotBox: "GA",
		Faculity:  "Philosophie",
	},
}

func main() {
	// Create a new campus vote storage with password "patrick4president"
	electionStorage := storage.New(*core.DefaultCampusVoteConf(), "patrick4president")

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
	fmt.Printf("\n === student election === \n")
	for i, voter := range LIST_OF_VOTERS {
		if i%2 != 0 {
			// Ever second student votes!! <3 ( and surprisingly in the morning on its home ballotbox :D )
			if err := electionStorage.SetVoterAsVoted(voter, voter.BallotBox, false); err != nil {
				fmt.Println(err) // voter already voted
			} else {
				fmt.Printf("%s %s (%d) votes!\n", voter.Firstname, voter.Lastname, voter.StudentId)
			}
		}
	}

	// See who allready voted
	fmt.Printf("\n === election: student already voted? === \n")
	for _, voter := range LIST_OF_VOTERS {
		// CheckVoterStatus will always return a status; on error it will be false
		if electionStorage.CheckVoterStatus(voter) {
			fmt.Printf("%s %s (%d): voted :)\n", voter.Firstname, voter.Lastname, voter.StudentId)
		} else {
			fmt.Printf("%s %s (%d): not voted :(\n", voter.Firstname, voter.Lastname, voter.StudentId)
		}
	}

	// Get insights to ongoing elections
	fmt.Printf("\n === election statistics === \n")
	fmt.Printf("%+v", electionStorage.GetElectionStats())
}
