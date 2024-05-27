package api

import (
	context "context"
	"log"
	"net"

	"google.golang.org/grpc"

	"github.com/domai-tb/campus_vote/pkg/core"
	"github.com/domai-tb/campus_vote/pkg/storage"
)

const (
	serverCertFile   = "certs/server-cert.pem"
	serverKeyFile    = "certs/server-key.pem"
	clientCACertFile = "certs/ca-cert.pem"
)

type CampusVoteAPI struct {
	cvdb storage.CampusVoteStorage
	UnimplementedCampusVoteServer
}

func New(cvdb storage.CampusVoteStorage) {
	lis, err := net.Listen("tcp", ":21797")
	if err != nil {
		log.Fatalf("cannot listen on port 21797: %s", err)
	}

	tlsCred, err := loadTLSCredentials()
	if err != nil {
		log.Fatalf("cannot load TLS credentials: %s", err)
	}

	gRPCServer := grpc.NewServer(
		grpc.Creds(tlsCred),
	)
	campusVoteService := &CampusVoteAPI{cvdb: cvdb}

	RegisterCampusVoteServer(gRPCServer, campusVoteService)
	if err = gRPCServer.Serve(lis); err != nil {
		log.Fatalf("cannot serve gRPC server: %s", err)
	}
}

func (cvapi *CampusVoteAPI) CreateVoter(c context.Context, v *Voter) (*StatusCode, error) {
	err := cvapi.cvdb.CreateNewVoter(storage.Voter{
		Firstname: v.Firstname,
		Lastname:  v.Lastname,
		StudentId: int(v.StudentId.Num),
		BallotBox: v.BallotBox,
		Faculity:  v.Faculity,
	})

	if err == nil {
		return statusOk(), nil
	}

	cvErr, ok := err.(*core.CampusVoteError)
	if ok {
		return &StatusCode{Status: cvErr.StatusCode, Msg: cvErr.ErrorMsg}, nil
	}

	return statusUnexpectedError(err.Error()), err
}

func (cvapi *CampusVoteAPI) GetVoterByStudentId(c context.Context, id *StudentId) (*Voter, error) {
	student, err := cvapi.cvdb.GetVoterByStudentId(int(id.Num))

	if err == nil {
		return &Voter{
			Firstname: student.Firstname,
			Lastname:  student.Lastname,
			StudentId: &StudentId{Num: int64(student.StudentId)},
			BallotBox: student.BallotBox,
			Faculity:  student.Faculity,
		}, nil
	}

	return nil, err
}

func (cvapi *CampusVoteAPI) SetVoterAsVoted(c context.Context, id *StudentId) (*StatusCode, error) {
	err := cvapi.cvdb.SetVoterAsVotedByStudentId(int(id.Num))

	if err == nil {
		return statusOk(), nil
	}

	cvErr, ok := err.(*core.CampusVoteError)
	if ok {
		return &StatusCode{Status: cvErr.StatusCode, Msg: cvErr.ErrorMsg}, nil
	}

	return statusUnexpectedError(err.Error()), err
}

func (cvapi *CampusVoteAPI) CheckVoterStatus(c context.Context, id *StudentId) (*StatusCode, error) {
	status, err := cvapi.cvdb.CheckVoterStatusByStudentId(int(id.Num))

	if err != nil {
		return statusStudentNotFound(), nil
	}

	if status {
		return statusStudentAllreadyVoted(), nil
	}

	return statusOk(), nil
}

func (cvapi *CampusVoteAPI) GetElectionStats(context.Context, *Void) (*ElectionStats, error) {
	stats := cvapi.cvdb.GetElectionStats()
	return storageStatsToElectionStats(stats), nil
}
