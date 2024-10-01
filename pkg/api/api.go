package api

import (
	context "context"
	"fmt"
	"net"
	"time"

	"google.golang.org/grpc"
	"google.golang.org/protobuf/types/known/timestamppb"

	"github.com/domai-tb/campus_vote/pkg/core"
	"github.com/domai-tb/campus_vote/pkg/storage"
)

type CampusVoteAPI struct {
	cvdb storage.CampusVoteStorage
	UnimplementedVoteServer
	UnimplementedChatServer
}

func New(cvdb storage.CampusVoteStorage) {
	lis, err := net.Listen("tcp", "127.0.0.1:21797")
	if err != nil {
		panic(err)
	}

	config := cvdb.GetConfig()

	tlsCred, err := loadTLSCredentials(config.APIRootCert, config.ServerCert, config.ServerKey)
	if err != nil {
		panic(err)
	}

	gRPCServer := grpc.NewServer(
		grpc.Creds(tlsCred),
	)

	campusVoteService := &CampusVoteAPI{cvdb: cvdb}

	// Register gRPC services
	RegisterVoteServer(gRPCServer, campusVoteService)
	RegisterChatServer(gRPCServer, campusVoteService)

	// Start CampusVote API server on port 21797
	if err = gRPCServer.Serve(lis); err != nil {
		panic(err)
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

func (cvapi *CampusVoteAPI) RegisterVotingStep(c context.Context, req *VoteReq) (*StatusCode, error) {

	// Get client that calls the gRPC
	boxName, err := getBoxNameFromTLSCert(c)
	if err != nil {
		return statusUnexpectedError(err.Error()), core.UnexpectedError(err.Error())
	}

	err = cvapi.cvdb.SetVoterAsVotedByStudentId(int(req.GetStudentId().GetNum()), boxName, req.GetIsAfternoon())
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

	switch status {
	case 2:
		return statusStudentAllreadyVoted(), nil
	case 1:
		return statusStudentAllreadyBallot(), nil
	case 0:
		return statusOk(), nil
	}

	return statusUnexpectedError(fmt.Sprintf("received undefinied voter status: %d", status)), nil
}

func (cvapi *CampusVoteAPI) GetElectionStats(context.Context, *Void) (*ElectionStats, error) {
	stats := cvapi.cvdb.GetElectionStats()
	return storageStatsToElectionStats(stats), nil
}

func (cvapi *CampusVoteAPI) SendChatMessage(c context.Context, msg *ChatMessage) (*StatusCode, error) {
	// Get client that calls the gRPC
	boxName, err := getBoxNameFromTLSCert(c)
	if err != nil {
		return statusUnexpectedError(err.Error()), core.UnexpectedError(err.Error())
	}

	err = cvapi.cvdb.SendChatMessage(storage.ChatMessage{
		SendAt:        time.Now(),
		BallotBoxName: boxName,
		Message:       msg.GetMessage(),
	})

	if err != nil {
		return statusFailedToSendChatMessage(), core.FailedToSendChatMessageError()
	}

	return statusOk(), nil
}

func (cvapi *CampusVoteAPI) ReadChatHistory(context.Context, *Void) (*ChatHistory, error) {
	var chatHistory []*ChatMessage

	chat, err := cvapi.cvdb.ReadChat()
	if err != nil {
		return nil, core.FailedToReadChatHistoryError()
	}

	for _, msg := range chat {
		chatHistory = append(chatHistory, &ChatMessage{
			Message: msg.Message,
			Sender:  msg.BallotBoxName,
			SendAt:  timestamppb.New(msg.SendAt),
		})
	}

	return &ChatHistory{Chat: chatHistory}, nil
}
