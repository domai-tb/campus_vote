package storage

import (
	"time"
)

type VotingDay struct {
	Total     int
	Morning   int
	Afternoon int
}

type BallotBox struct {
	BallotBoxName string `gorm:"primaryKey"`
	TotalVotes    int
	VotesPerDay   [5]VotingDay `gorm:"type:bytes;serializer:json"`
}

type ElectionStats struct {
	ElectionYear int `gorm:"primaryKey"`
	TotalVotes   int
	BallotBoxs   []BallotBox `gorm:"type:bytes;serializer:json"`
}

func newStats(year int, ballotboxes []string) *ElectionStats {

	var boxes []BallotBox
	for _, box := range ballotboxes {
		boxes = append(boxes, BallotBox{
			BallotBoxName: box,
			TotalVotes:    0,
			VotesPerDay: [5]VotingDay{
				{ // monday
					Total:     0,
					Morning:   0,
					Afternoon: 0,
				},
				{ // tuesday
					Total:     0,
					Morning:   0,
					Afternoon: 0,
				},
				{ // wendsday
					Total:     0,
					Morning:   0,
					Afternoon: 0,
				},
				{ // thursday
					Total:     0,
					Morning:   0,
					Afternoon: 0,
				},
				{ // friday
					Total:     0,
					Morning:   0,
					Afternoon: 0,
				},
			},
		})
	}

	return &ElectionStats{
		ElectionYear: year,
		TotalVotes:   0,
		BallotBoxs:   boxes,
	}
}

func (cvdb *CampusVoteStorage) GetElectionStats() ElectionStats {
	db := cvdb.conf.GetCockroachDB()

	var stats ElectionStats
	db.First(&stats)

	return stats
}

func (cvdb *CampusVoteStorage) countVote(ballotbox string) {
	db := cvdb.conf.GetCockroachDB()

	var stats ElectionStats
	db.First(&stats)

	// find correct ballot box
	var indexOfBoxToCount int
	for i, box := range stats.BallotBoxs {
		if box.BallotBoxName == ballotbox {
			indexOfBoxToCount = i
		}
	}

	currentTime := time.Now().Local()
	currentDay := currentTime.Weekday() - 1 // weekday => 1...7; index => 0...5

	stats.TotalVotes += 1
	stats.BallotBoxs[indexOfBoxToCount].TotalVotes += 1
	stats.BallotBoxs[indexOfBoxToCount].VotesPerDay[currentDay].Total += 1

	if morOrAft := currentTime.Hour(); morOrAft <= 12 {
		stats.BallotBoxs[indexOfBoxToCount].VotesPerDay[currentDay].Morning += 1
	} else {
		stats.BallotBoxs[indexOfBoxToCount].VotesPerDay[currentDay].Afternoon += 1
	}

	db.Save(&stats)
}
