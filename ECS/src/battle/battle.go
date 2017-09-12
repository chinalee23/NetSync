package battle

import (
	"encoding/json"
	"fmt"
	"network"
	"time"
)

type Player struct {
	sockIndex int
	ready     bool
}

type stMessage struct {
	MsgType string           `json:"msgType"`
	Data    *json.RawMessage `json:"data"`
}

type protoFight struct {
	MsgType  string `json:"msgType"`
	PlayerId int    `json:"playerId"`
}

type protoFrame struct {
	MsgType string             `json:"msgType"`
	Data    []*json.RawMessage `json:"data"`
}

const (
	max_player_count = 1
)

var players map[int]*Player
var frames []*json.RawMessage
var frameNo int
var frameReadyCount int

func start() {
	for {
		for {
			msg := network.GetMessage()
			if msg == nil {
				break
			} else {
				processMsg(msg)
			}
		}

		time.Sleep(10 * time.Microsecond)
	}
}

func processMsg(msg *network.Message) {
	fmt.Println(string(msg.Data))
	var jd stMessage
	err := json.Unmarshal(msg.Data, &jd)
	if err != nil {
		fmt.Println("unmarshal error: ", err)
		return
	}
	switch jd.MsgType {
	case "enter":
		processEnter(msg)
		break
	case "frame":
		processFrame(jd.Data)
		break
	}
}

func processEnter(msg *network.Message) {
	fmt.Println("enter one player")
	player := &Player{
		sockIndex: msg.SockIndex,
		ready:     false,
	}
	players[msg.SockIndex] = player

	if len(players) < max_player_count {
		return
	}

	for i, player := range players {
		js := protoFight{
			MsgType:  "fight",
			PlayerId: i,
		}
		jd, err := json.Marshal(js)
		if err != nil {
			fmt.Println("marshal error: ", err)
			return
		}
		network.Send(player.sockIndex, jd)
	}

	frames = make([]*json.RawMessage, 0)
	frameNo = 1
	frameReadyCount = 0
}

func processFrame(data *json.RawMessage) {
	frameReadyCount++
	frames = append(frames, data)
	if len(frames) < max_player_count {
		return
	}

	fmt.Println("frame [ ", frameNo, " ] all ready")
	for _, player := range players {
		js := protoFrame{
			MsgType: "frame",
			Data:    frames,
		}
		jd, err := json.Marshal(js)
		if err != nil {
			fmt.Println("marshal error: ", err)
			return
		}
		network.Send(player.sockIndex, jd)
	}

	frames = make([]*json.RawMessage, 0)
	frameNo++
	frameReadyCount = 0
}

func Start() {
	fmt.Println("battle start")

	players = make(map[int]*Player)

	go start()
}
