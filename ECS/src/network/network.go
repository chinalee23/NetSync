package network

import (
	"fmt"
	"net"
)

type stConnection struct {
	socket net.Conn
	index  int
}

var guid int
var mapConnection map[int]*stConnection

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
		len, err := conn.socket.Read(data)
		if err != nil {
			fmt.Println("read error: ", err)
			return
		}
		fmt.Println("receve data, len: ", len)
		msg := &Message{
			Data:      data[:len],
			SockIndex: conn.index,
		}
		saveMessage(msg)
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
	conn := mapConnection[index]
	len, err := conn.socket.Write(data)
	if err != nil {
		fmt.Println("send error: ", err)
		return
	}
	fmt.Println("send success, len: ", len)
}
