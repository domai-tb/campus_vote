package storage

import (
	"fmt"
	"time"
)

type ChatMessage struct {
	SendAt        time.Time `gorm:"primaryKey;<-:create"`
	Message       string    `gorm:"<-:create"`
	BallotBoxName string    `gorm:"<-:create"`
}

type EncChatMessage struct {
	SendAt        time.Time `gorm:"primaryKey;<-:create"`
	Message       []byte    `gorm:"type:bytes;<-:create"`
	BallotBoxName []byte    `gorm:"type:bytes;<-:create"`
}

func (cvdb *CampusVoteStorage) encryptChatMessage(msg ChatMessage) EncChatMessage {
	return EncChatMessage{
		SendAt:        msg.SendAt,
		Message:       cvdb.encrypt(msg.Message),
		BallotBoxName: cvdb.encrypt(msg.BallotBoxName),
	}
}

func (cvdb *CampusVoteStorage) decryptChatMessage(msg EncChatMessage) (ChatMessage, error) {
	message, err := cvdb.decrypt(msg.Message)
	if err != nil {
		return ChatMessage{}, fmt.Errorf("failed to decrypt chat message: %w", err)
	}

	bbname, err := cvdb.decrypt(msg.BallotBoxName)
	if err != nil {
		return ChatMessage{}, fmt.Errorf("failed to decrypt chat message: %w", err)
	}

	return ChatMessage{
		SendAt:        msg.SendAt,
		BallotBoxName: bbname,
		Message:       message,
	}, nil
}

//
//*     Sorting Slices accordingly to SendAt field.
//*     Implemented the required sort.Sort() interface.
//
//      Check out:
//          https://medium.com/@briankworld/how-to-implement-custom-sorting-with-custom-structs-in-go-322e9c1d26b8
//

type chatMessageSlice []ChatMessage
type encChatMessageSlice []EncChatMessage

func (msg chatMessageSlice) Len() int {
	return len(msg)
}

func (msg chatMessageSlice) Less(i, j int) bool {
	return msg[i].SendAt.Before(msg[j].SendAt)
}

func (msg chatMessageSlice) Swap(i, j int) {
	msg[i], msg[j] = msg[j], msg[i]
}

func (msg encChatMessageSlice) Len() int {
	return len(msg)
}

func (msg encChatMessageSlice) Less(i, j int) bool {
	return msg[i].SendAt.Before(msg[j].SendAt)
}

func (msg encChatMessageSlice) Swap(i, j int) {
	msg[i], msg[j] = msg[j], msg[i]
}
