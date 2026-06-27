package api

import (
	"context"
	"crypto/tls"
	"crypto/x509"
	"fmt"
	"log"
	"os"
	"strconv"
	"time"

	"google.golang.org/grpc"
	"google.golang.org/grpc/credentials"
)

type CampusVoteAPIClient struct {
	voteClient VoteClient
	chatClient ChatClient
}

func NewClient(rootCert, clientCert, clientKey string) (*CampusVoteAPIClient, error) {
	// Load root certificate
	certPool := x509.NewCertPool()
	rootCertBytes, err := os.ReadFile(rootCert)
	if err != nil {
		return nil, fmt.Errorf("failed to read root certificate: %w", err)
	}
	if ok := certPool.AppendCertsFromPEM(rootCertBytes); !ok {
		return nil, fmt.Errorf("failed to append root certificate")
	}

	// Load client certificate and key
	clientCertificate, err := tls.LoadX509KeyPair(clientCert, clientKey)
	if err != nil {
		return nil, fmt.Errorf("failed to load client certificate and key: %w", err)
	}

	// Set up TLS credentials
	tlsConfig := &tls.Config{
		Certificates:       []tls.Certificate{clientCertificate},
		RootCAs:            certPool,
		InsecureSkipVerify: false,
		ServerName:         "127.0.0.1", // Server name must match the authority name
	}
	creds := credentials.NewTLS(tlsConfig)

	// Set up gRPC connection
	conn, err := grpc.NewClient("127.0.0.1:21797", grpc.WithTransportCredentials(creds))
	if err != nil {
		return nil, fmt.Errorf("failed to establish gRPC connection: %w", err)
	}

	return &CampusVoteAPIClient{
		voteClient: NewVoteClient(conn),
		chatClient: NewChatClient(conn),
	}, nil
}

func (c *CampusVoteAPIClient) VotingStep(studentID string, isAfternoon *bool) (string, error) {
	ctx, cancel := context.WithTimeout(context.Background(), time.Second*3600)
	defer cancel()

	voteReq := &VoteReq{
		StudentId:   &StudentId{Num: parseLongInt(studentID)},
		IsAfternoon: *isAfternoon,
	}

	status, err := c.voteClient.RegisterVotingStep(ctx, voteReq)
	if err != nil {
		return "", fmt.Errorf("failed to register voting step: %w", err)
	}
	return status.Msg, nil
}

func (c *CampusVoteAPIClient) GetElectionStats() (*ElectionStats, error) {
	ctx, cancel := context.WithTimeout(context.Background(), time.Second*3600)
	defer cancel()

	stats, err := c.voteClient.GetElectionStats(ctx, &Void{})
	if err != nil {
		return nil, fmt.Errorf("failed to get election stats: %w", err)
	}
	return stats, nil
}

func (c *CampusVoteAPIClient) SendChatMessage(message string) (*StatusCode, error) {
	ctx, cancel := context.WithTimeout(context.Background(), time.Second*3600)
	defer cancel()

	chatMsg := &ChatMessage{Message: message}
	status, err := c.chatClient.SendChatMessage(ctx, chatMsg)
	if err != nil {
		return nil, fmt.Errorf("failed to send chat message: %w", err)
	}
	return status, nil
}

func (c *CampusVoteAPIClient) GetChatHistory() (*ChatHistory, error) {
	ctx, cancel := context.WithTimeout(context.Background(), time.Second*3600)
	defer cancel()

	history, err := c.chatClient.ReadChatHistory(ctx, &Void{})
	if err != nil {
		return nil, fmt.Errorf("failed to get chat history: %w", err)
	}
	return history, nil
}

func (c *CampusVoteAPIClient) GetVoterByStudentID(studentID string) (*Voter, error) {
	ctx, cancel := context.WithTimeout(context.Background(), time.Second*3600)
	defer cancel()

	voter, err := c.voteClient.GetVoterByStudentId(ctx, &StudentId{Num: parseLongInt(studentID)})
	if err != nil {
		return nil, fmt.Errorf("failed to get voter: %w", err)
	}
	return voter, nil
}

func (c *CampusVoteAPIClient) CreateVoter(voter *Voter) (*StatusCode, error) {
	ctx, cancel := context.WithTimeout(context.Background(), time.Second*3600)
	defer cancel()

	status, err := c.voteClient.CreateVoter(ctx, voter)
	if err != nil {
		return nil, fmt.Errorf("failed to create voter: %w", err)
	}
	return status, nil
}

func parseLongInt(numStr string) int64 {
	num, err := strconv.ParseInt(numStr, 10, 64)
	if err != nil {
		log.Fatalf("Failed to parse long int: %v", err)
	}
	return num
}
