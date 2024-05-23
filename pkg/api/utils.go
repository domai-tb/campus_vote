package api

import "github.com/domai-tb/campus_vote/pkg/storage"

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
