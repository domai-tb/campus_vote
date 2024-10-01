// Code generated by protoc-gen-go-grpc. DO NOT EDIT.
// versions:
// - protoc-gen-go-grpc v1.5.1
// - protoc             v5.28.2
// source: vote.proto

package api

import (
	context "context"
	grpc "google.golang.org/grpc"
	codes "google.golang.org/grpc/codes"
	status "google.golang.org/grpc/status"
)

// This is a compile-time assertion to ensure that this generated file
// is compatible with the grpc package it is being compiled against.
// Requires gRPC-Go v1.64.0 or later.
const _ = grpc.SupportPackageIsVersion9

const (
	Vote_CreateVoter_FullMethodName         = "/CampusVote.Vote/CreateVoter"
	Vote_GetVoterByStudentId_FullMethodName = "/CampusVote.Vote/GetVoterByStudentId"
	Vote_RegisterVotingStep_FullMethodName  = "/CampusVote.Vote/RegisterVotingStep"
	Vote_CheckVoterStatus_FullMethodName    = "/CampusVote.Vote/CheckVoterStatus"
	Vote_GetElectionStats_FullMethodName    = "/CampusVote.Vote/GetElectionStats"
)

// VoteClient is the client API for Vote service.
//
// For semantics around ctx use and closing/ending streaming RPCs, please refer to https://pkg.go.dev/google.golang.org/grpc/?tab=doc#ClientConn.NewStream.
type VoteClient interface {
	CreateVoter(ctx context.Context, in *Voter, opts ...grpc.CallOption) (*StatusCode, error)
	GetVoterByStudentId(ctx context.Context, in *StudentId, opts ...grpc.CallOption) (*Voter, error)
	RegisterVotingStep(ctx context.Context, in *VoteReq, opts ...grpc.CallOption) (*StatusCode, error)
	CheckVoterStatus(ctx context.Context, in *StudentId, opts ...grpc.CallOption) (*StatusCode, error)
	GetElectionStats(ctx context.Context, in *Void, opts ...grpc.CallOption) (*ElectionStats, error)
}

type voteClient struct {
	cc grpc.ClientConnInterface
}

func NewVoteClient(cc grpc.ClientConnInterface) VoteClient {
	return &voteClient{cc}
}

func (c *voteClient) CreateVoter(ctx context.Context, in *Voter, opts ...grpc.CallOption) (*StatusCode, error) {
	cOpts := append([]grpc.CallOption{grpc.StaticMethod()}, opts...)
	out := new(StatusCode)
	err := c.cc.Invoke(ctx, Vote_CreateVoter_FullMethodName, in, out, cOpts...)
	if err != nil {
		return nil, err
	}
	return out, nil
}

func (c *voteClient) GetVoterByStudentId(ctx context.Context, in *StudentId, opts ...grpc.CallOption) (*Voter, error) {
	cOpts := append([]grpc.CallOption{grpc.StaticMethod()}, opts...)
	out := new(Voter)
	err := c.cc.Invoke(ctx, Vote_GetVoterByStudentId_FullMethodName, in, out, cOpts...)
	if err != nil {
		return nil, err
	}
	return out, nil
}

func (c *voteClient) RegisterVotingStep(ctx context.Context, in *VoteReq, opts ...grpc.CallOption) (*StatusCode, error) {
	cOpts := append([]grpc.CallOption{grpc.StaticMethod()}, opts...)
	out := new(StatusCode)
	err := c.cc.Invoke(ctx, Vote_RegisterVotingStep_FullMethodName, in, out, cOpts...)
	if err != nil {
		return nil, err
	}
	return out, nil
}

func (c *voteClient) CheckVoterStatus(ctx context.Context, in *StudentId, opts ...grpc.CallOption) (*StatusCode, error) {
	cOpts := append([]grpc.CallOption{grpc.StaticMethod()}, opts...)
	out := new(StatusCode)
	err := c.cc.Invoke(ctx, Vote_CheckVoterStatus_FullMethodName, in, out, cOpts...)
	if err != nil {
		return nil, err
	}
	return out, nil
}

func (c *voteClient) GetElectionStats(ctx context.Context, in *Void, opts ...grpc.CallOption) (*ElectionStats, error) {
	cOpts := append([]grpc.CallOption{grpc.StaticMethod()}, opts...)
	out := new(ElectionStats)
	err := c.cc.Invoke(ctx, Vote_GetElectionStats_FullMethodName, in, out, cOpts...)
	if err != nil {
		return nil, err
	}
	return out, nil
}

// VoteServer is the server API for Vote service.
// All implementations must embed UnimplementedVoteServer
// for forward compatibility.
type VoteServer interface {
	CreateVoter(context.Context, *Voter) (*StatusCode, error)
	GetVoterByStudentId(context.Context, *StudentId) (*Voter, error)
	RegisterVotingStep(context.Context, *VoteReq) (*StatusCode, error)
	CheckVoterStatus(context.Context, *StudentId) (*StatusCode, error)
	GetElectionStats(context.Context, *Void) (*ElectionStats, error)
	mustEmbedUnimplementedVoteServer()
}

// UnimplementedVoteServer must be embedded to have
// forward compatible implementations.
//
// NOTE: this should be embedded by value instead of pointer to avoid a nil
// pointer dereference when methods are called.
type UnimplementedVoteServer struct{}

func (UnimplementedVoteServer) CreateVoter(context.Context, *Voter) (*StatusCode, error) {
	return nil, status.Errorf(codes.Unimplemented, "method CreateVoter not implemented")
}
func (UnimplementedVoteServer) GetVoterByStudentId(context.Context, *StudentId) (*Voter, error) {
	return nil, status.Errorf(codes.Unimplemented, "method GetVoterByStudentId not implemented")
}
func (UnimplementedVoteServer) RegisterVotingStep(context.Context, *VoteReq) (*StatusCode, error) {
	return nil, status.Errorf(codes.Unimplemented, "method RegisterVotingStep not implemented")
}
func (UnimplementedVoteServer) CheckVoterStatus(context.Context, *StudentId) (*StatusCode, error) {
	return nil, status.Errorf(codes.Unimplemented, "method CheckVoterStatus not implemented")
}
func (UnimplementedVoteServer) GetElectionStats(context.Context, *Void) (*ElectionStats, error) {
	return nil, status.Errorf(codes.Unimplemented, "method GetElectionStats not implemented")
}
func (UnimplementedVoteServer) mustEmbedUnimplementedVoteServer() {}
func (UnimplementedVoteServer) testEmbeddedByValue()              {}

// UnsafeVoteServer may be embedded to opt out of forward compatibility for this service.
// Use of this interface is not recommended, as added methods to VoteServer will
// result in compilation errors.
type UnsafeVoteServer interface {
	mustEmbedUnimplementedVoteServer()
}

func RegisterVoteServer(s grpc.ServiceRegistrar, srv VoteServer) {
	// If the following call pancis, it indicates UnimplementedVoteServer was
	// embedded by pointer and is nil.  This will cause panics if an
	// unimplemented method is ever invoked, so we test this at initialization
	// time to prevent it from happening at runtime later due to I/O.
	if t, ok := srv.(interface{ testEmbeddedByValue() }); ok {
		t.testEmbeddedByValue()
	}
	s.RegisterService(&Vote_ServiceDesc, srv)
}

func _Vote_CreateVoter_Handler(srv interface{}, ctx context.Context, dec func(interface{}) error, interceptor grpc.UnaryServerInterceptor) (interface{}, error) {
	in := new(Voter)
	if err := dec(in); err != nil {
		return nil, err
	}
	if interceptor == nil {
		return srv.(VoteServer).CreateVoter(ctx, in)
	}
	info := &grpc.UnaryServerInfo{
		Server:     srv,
		FullMethod: Vote_CreateVoter_FullMethodName,
	}
	handler := func(ctx context.Context, req interface{}) (interface{}, error) {
		return srv.(VoteServer).CreateVoter(ctx, req.(*Voter))
	}
	return interceptor(ctx, in, info, handler)
}

func _Vote_GetVoterByStudentId_Handler(srv interface{}, ctx context.Context, dec func(interface{}) error, interceptor grpc.UnaryServerInterceptor) (interface{}, error) {
	in := new(StudentId)
	if err := dec(in); err != nil {
		return nil, err
	}
	if interceptor == nil {
		return srv.(VoteServer).GetVoterByStudentId(ctx, in)
	}
	info := &grpc.UnaryServerInfo{
		Server:     srv,
		FullMethod: Vote_GetVoterByStudentId_FullMethodName,
	}
	handler := func(ctx context.Context, req interface{}) (interface{}, error) {
		return srv.(VoteServer).GetVoterByStudentId(ctx, req.(*StudentId))
	}
	return interceptor(ctx, in, info, handler)
}

func _Vote_RegisterVotingStep_Handler(srv interface{}, ctx context.Context, dec func(interface{}) error, interceptor grpc.UnaryServerInterceptor) (interface{}, error) {
	in := new(VoteReq)
	if err := dec(in); err != nil {
		return nil, err
	}
	if interceptor == nil {
		return srv.(VoteServer).RegisterVotingStep(ctx, in)
	}
	info := &grpc.UnaryServerInfo{
		Server:     srv,
		FullMethod: Vote_RegisterVotingStep_FullMethodName,
	}
	handler := func(ctx context.Context, req interface{}) (interface{}, error) {
		return srv.(VoteServer).RegisterVotingStep(ctx, req.(*VoteReq))
	}
	return interceptor(ctx, in, info, handler)
}

func _Vote_CheckVoterStatus_Handler(srv interface{}, ctx context.Context, dec func(interface{}) error, interceptor grpc.UnaryServerInterceptor) (interface{}, error) {
	in := new(StudentId)
	if err := dec(in); err != nil {
		return nil, err
	}
	if interceptor == nil {
		return srv.(VoteServer).CheckVoterStatus(ctx, in)
	}
	info := &grpc.UnaryServerInfo{
		Server:     srv,
		FullMethod: Vote_CheckVoterStatus_FullMethodName,
	}
	handler := func(ctx context.Context, req interface{}) (interface{}, error) {
		return srv.(VoteServer).CheckVoterStatus(ctx, req.(*StudentId))
	}
	return interceptor(ctx, in, info, handler)
}

func _Vote_GetElectionStats_Handler(srv interface{}, ctx context.Context, dec func(interface{}) error, interceptor grpc.UnaryServerInterceptor) (interface{}, error) {
	in := new(Void)
	if err := dec(in); err != nil {
		return nil, err
	}
	if interceptor == nil {
		return srv.(VoteServer).GetElectionStats(ctx, in)
	}
	info := &grpc.UnaryServerInfo{
		Server:     srv,
		FullMethod: Vote_GetElectionStats_FullMethodName,
	}
	handler := func(ctx context.Context, req interface{}) (interface{}, error) {
		return srv.(VoteServer).GetElectionStats(ctx, req.(*Void))
	}
	return interceptor(ctx, in, info, handler)
}

// Vote_ServiceDesc is the grpc.ServiceDesc for Vote service.
// It's only intended for direct use with grpc.RegisterService,
// and not to be introspected or modified (even as a copy)
var Vote_ServiceDesc = grpc.ServiceDesc{
	ServiceName: "CampusVote.Vote",
	HandlerType: (*VoteServer)(nil),
	Methods: []grpc.MethodDesc{
		{
			MethodName: "CreateVoter",
			Handler:    _Vote_CreateVoter_Handler,
		},
		{
			MethodName: "GetVoterByStudentId",
			Handler:    _Vote_GetVoterByStudentId_Handler,
		},
		{
			MethodName: "RegisterVotingStep",
			Handler:    _Vote_RegisterVotingStep_Handler,
		},
		{
			MethodName: "CheckVoterStatus",
			Handler:    _Vote_CheckVoterStatus_Handler,
		},
		{
			MethodName: "GetElectionStats",
			Handler:    _Vote_GetElectionStats_Handler,
		},
	},
	Streams:  []grpc.StreamDesc{},
	Metadata: "vote.proto",
}
