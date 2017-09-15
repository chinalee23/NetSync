package network

import (
	"bytes"
	"encoding/binary"
	"fmt"
	"net"
)

type stConnection struct {
	socket net.Conn
	index  int
}

var guid int
var mapConnection map[int]*stConnection

func toBytes(n int) []byte {
	tmp := int32(n)
	bytesBuffer := bytes.NewBuffer([]byte{})
	binary.Write(bytesBuffer, binary.BigEndian, tmp)
	return bytesBuffer.Bytes()
}

func toInt(b []byte) int {
	bytesBuffer := bytes.NewBuffer(b)
	var tmp int32
	binary.Read(bytesBuffer, binary.BigEndian, &tmp)
	return int(tmp)
}

func handleConnect(socket net.Conn) {
	conn := &stConnection{
		socket: socket,
		index:  guid,
	}
	mapConnection[guid] = conn
	guid++
	go recv(conn)
}

func recv(conn *stConnection) {
	defer func() {
		conn.socket.Close()
	}()

	for {
		data := make([]byte, 1024)
		recvLen, err := conn.socket.Read(data)
		if err != nil {
			fmt.Println("read error: ", err)
			return
		}

		offset := 0
		for offset < recvLen {
			dataLen := toInt(data)
			msg := &Message{
				Data:      data[4:dataLen],
				SockIndex: conn.index,
			}
			saveMessage(msg)
			data = data[dataLen:]
			offset += dataLen
		}
	}
}

func listen() {
	listen, err := net.Listen("tcp", ":12345")
	if err != nil {
		fmt.Println("listen error: ", err)
		return
	}
	fmt.Println("listening...")

	for {
		conn, err := listen.Accept()
		if err != nil {
			fmt.Println("accept error: ", err)
			break
		}

		handleConnect(conn)
	}
}

func Start() {
	fmt.Println("net start")

	mapConnection = make(map[int]*stConnection)
	guid = 0

	go listen()
}

func Send(index int, data []byte) {
	sLen := toBytes(len(data) + 4)
	msg := make([]byte, 0)
	msg = append(msg, sLen...)
	msg = append(msg, data...)
	conn := mapConnection[index]
	_, err := conn.socket.Write(msg)
	if err != nil {
		fmt.Println("send error: ", err)
		return
	}
}
