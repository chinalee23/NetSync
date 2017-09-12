package network

import (
	"sync"
)

type Message struct {
	Data      []byte
	SockIndex int
}

var messages []*Message
var wg sync.WaitGroup

func initMessage() {
	messages = make([]*Message, 0)
}

func saveMessage(msg *Message) {
	wg.Wait()
	wg.Add(1)
	messages = append(messages, msg)
	wg.Done()
}

func GetMessage() *Message {
	wg.Wait()

	if len(messages) == 0 {
		return nil
	}

	wg.Add(1)
	msg := messages[0]
	messages = append(messages[:0], messages[1:]...)
	wg.Done()

	return msg
}
