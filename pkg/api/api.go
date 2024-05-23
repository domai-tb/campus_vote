package api

import (
	context "context"
	"crypto/tls"
	"crypto/x509"
	"fmt"
	"log"
	"net"
	"os"

	"google.golang.org/grpc"
	"google.golang.org/grpc/credentials"

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
	if cvapi.cvdb.CheckVoterStatusByStudentId(int(id.Num)) {
		return statusStudentAllreadyVoted(), nil
	}
	return statusOk(), nil
}

func loadTLSCredentials() (credentials.TransportCredentials, error) {
	// Load certificate of the CA who signed client's certificate
	pemClientCA, err := os.ReadFile(clientCACertFile)
	if err != nil {
		return nil, err
	}

	certPool := x509.NewCertPool()
	if !certPool.AppendCertsFromPEM(pemClientCA) {
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
	}

	return credentials.NewTLS(config), nil
}
