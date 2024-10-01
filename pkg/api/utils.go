package api

import (
	context "context"
	"crypto/tls"
	"crypto/x509"
	"fmt"
	"os"

	"google.golang.org/grpc/credentials"
	"google.golang.org/grpc/peer"

	"github.com/domai-tb/campus_vote/pkg/storage"
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

func statusStudentAllreadyBallot() *StatusCode {
	return &StatusCode{Status: 6, Msg: "student allready got a ballot"}
}

func statusFailedToSendChatMessage() *StatusCode {
	return &StatusCode{Status: 5, Msg: "failed to send chat message"}
}

func loadTLSCredentials(rootCACertFile, serverCertFile, serverKeyFile string) (credentials.TransportCredentials, error) {
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
	serverCert, err := tls.LoadX509KeyPair(serverCertFile, serverKeyFile)
	if err != nil {
		return nil, err
	}

	// Create the credentials and return it
	config := &tls.Config{
		Certificates: []tls.Certificate{serverCert},
		ClientAuth:   tls.RequireAndVerifyClientCert,
		ClientCAs:    certPool,
		MinVersion:   tls.VersionTLS13,
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

func getBoxNameFromTLSCert(c context.Context) (string, error) {
	// Get client that calls the gRPC
	client, ok := peer.FromContext(c)
	if !ok {
		return "", fmt.Errorf("failed to read clients TLS certificate")
	}

	// Get ballotbox name from TLS certificate of mTLS connection
	// https://github.com/grpc/grpc-go/issues/111#issuecomment-275820771
	tlsInfo := client.AuthInfo.(credentials.TLSInfo)
	boxName := tlsInfo.State.VerifiedChains[0][0].Subject.CommonName

	return boxName, nil
}
