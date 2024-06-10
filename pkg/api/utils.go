package api

import (
	"crypto/tls"
	"crypto/x509"
	"fmt"
	"os"

	"github.com/domai-tb/campus_vote/pkg/storage"
	"google.golang.org/grpc/credentials"
)

func strgVtrToAPIVtr(v storage.Voter) Voter {
	return Voter{
		Firstname: v.Firstname,
		Lastname:  v.Lastname,
		StudentId: &StudentId{Num: int64(v.StudentId)},
		BallotBox: v.BallotBox,
		Faculity:  v.Faculity,
	}
}

func apiVtrToStrgVtr(v *Voter) storage.Voter {
	return storage.Voter{
		Firstname: v.Firstname,
		Lastname:  v.Lastname,
		StudentId: int(v.StudentId.Num),
		BallotBox: v.BallotBox,
		Faculity:  v.Faculity,
	}
}

func statusOk() *StatusCode {
	return &StatusCode{Status: 0, Msg: "no error"}
}

func statusUnexpectedError(msg string) *StatusCode {
	return &StatusCode{Status: -1, Msg: msg}
}

func statusStudentAllreadyExists() *StatusCode {
	return &StatusCode{Status: 1, Msg: "student allready exists"}
}

func statusStudentNotFound() *StatusCode {
	return &StatusCode{Status: 2, Msg: "student not found"}
}

func statusStudentAllreadyVoted() *StatusCode {
	return &StatusCode{Status: 3, Msg: "student allready voted"}
}

func loadTLSCredentials() (credentials.TransportCredentials, error) {
	// Load certificate of the CA who signed client's certificate
	rootCA, err := os.ReadFile(rootCACertFile)
	if err != nil {
		return nil, err
	}

	certPool := x509.NewCertPool()
	if !certPool.AppendCertsFromPEM(rootCA) {
		return nil, fmt.Errorf("failed to add client CA's certificate")
	}

	// Load server's certificate and private key
	// TODO: Load from keychain / credential manager via  tls.X509KeyPair([]bytes, []bytes)
	serverCert, err := tls.LoadX509KeyPair(serverCertFile, serverKeyFile)
	if err != nil {
		return nil, err
	}

	// Create the credentials and return it
	config := &tls.Config{
		Certificates: []tls.Certificate{serverCert},
		ClientAuth:   tls.RequireAndVerifyClientCert,
		ClientCAs:    certPool,
	}

	return credentials.NewTLS(config), nil
}

func storageStatsToElectionStats(s storage.ElectionStats) *ElectionStats {
	// create gRPC ballotboxes
	var boxStats []*BallotBoxStats
	for _, box := range s.BallotBoxs {
		// create gRPC days
		var votingDays []*VotingDayStats
		for _, day := range box.VotesPerDay {
			votingDays = append(votingDays, &VotingDayStats{
				TotalVotes:     int64(day.Total),
				MorningVotes:   int64(day.Morning),
				AfternoonVotes: int64(day.Afternoon),
			})
		}

		boxStats = append(boxStats, &BallotBoxStats{
			Name:        box.BallotBoxName,
			TotalVotes:  int64(box.TotalVotes),
			VotesPerDay: votingDays,
		})
	}

	return &ElectionStats{
		ElectionYear: int32(s.ElectionYear),
		TotalVotes:   int64(s.TotalVotes),
		BallotBoxes:  boxStats,
	}
}
