package core

import "fmt"

type CampusVoteError struct {
	ErrorMsg string
	// -1 => something unexpected
	// 0  => no error
	// 1  => student allready exists
	// 2  => student not found
	// 3  => student allready voted
	// 4  => ballotboy doesn't exist
	// 5  => failed to send chat message
	StatusCode int32
}

func (e *CampusVoteError) Error() string {
	return fmt.Sprintf("%d: %s", e.StatusCode, e.ErrorMsg)
}

func UnexpectedError(msg string) error {
	return &CampusVoteError{StatusCode: -1, ErrorMsg: msg}
}

func StudentAllreadyExistsError() error {
	return &CampusVoteError{StatusCode: 1, ErrorMsg: "student allready exists"}
}

func StudentNotFoundError() error {
	return &CampusVoteError{StatusCode: 2, ErrorMsg: "student not found"}
}

func StudentAllreadyVotedError() error {
	return &CampusVoteError{StatusCode: 3, ErrorMsg: "student allready voted"}
}

func BallotBoxDoesNotExistError() error {
	return &CampusVoteError{StatusCode: 4, ErrorMsg: "ballotbox does not exist"}
}

func FailedToSendChatMessageError() error {
	return &CampusVoteError{StatusCode: 5, ErrorMsg: "failed to send chat message"}
}

func FailedToReadChatHistoryError() error {
	return &CampusVoteError{StatusCode: 7, ErrorMsg: "failed to read chat history"}
}

func FailedToCreateVoterError(msg string) error {
	return &CampusVoteError{StatusCode: 8, ErrorMsg: fmt.Sprintf("failed to create voter: %s", msg)}
}
