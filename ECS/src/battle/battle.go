package battle

import (
	"encoding/json"
	"fmt"
	"network"
	"sync"
	"time"
)

type Player struct {
	sockIndex int
	ready     bool
	delay     int
}

type stMessage struct {
	MsgType string           `json:"msgType"`
	Data    *json.RawMessage `json:"data"`
}

type protoCommon struct {
	MsgType string `json:"msgType"`
}

type protoEnterRsp struct {
	MsgType  string `json:"msgType"`
	PlayerId int    `json:"playerId"`
}

type protoBattleStart struct {
	MsgType   string `json:"msgType"`
	PlayerIds []int  `json:"playerIds"`
}

type protoFight struct {
	MsgType string `json:"msgType"`
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
var playerReadyCount int
var wg sync.WaitGroup

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

		time.Sleep(10 * time.Millisecond)
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
		processEnter(msg.SockIndex)
		break
	case "ready":
		processReady()
	case "frame":
		processFrame(jd.Data)
		break
	}
}

func processEnter(sockIndex int) {
	fmt.Println("enter one player")
	player := &Player{
		sockIndex: sockIndex,
		ready:     false,
		delay:     0,
	}
	players[sockIndex] = player
	sendEnterRsp(player)

	if len(players) == max_player_count {
		fmt.Println("all players in, battleStart")
		sendBattleStart()

		frames = make([]*json.RawMessage, 0)
		frameNo = 1
		frameReadyCount = 0
		playerReadyCount = 0
	}
}

func sendEnterRsp(player *Player) {
	js := protoEnterRsp{
		MsgType:  "enterRsp",
		PlayerId: len(players),
	}
	jd, err := json.Marshal(js)
	if err != nil {
		fmt.Println("marshal error: ", err)
		return
	}
	network.Send(player.sockIndex, jd)
}

func sendBattleStart() {
	playerIds := make([]int, len(players))
	for i := 0; i < len(players); i++ {
		playerIds[i] = i + 1
	}
	for _, player := range players {
		js := protoBattleStart{
			MsgType:   "battleStart",
			PlayerIds: playerIds,
		}
		jd, err := json.Marshal(js)
		if err != nil {
			fmt.Println("marshal error: ", err)
			return
		}
		fmt.Println("send battle start to", player.sockIndex)
		network.Send(player.sockIndex, jd)
	}
}

func processReady() {
	playerReadyCount++
	if playerReadyCount != len(players) {
		return
	}

	for _, player := range players {
		js := protoFight{
			MsgType: "fight",
		}
		jd, err := json.Marshal(js)
		if err != nil {
			fmt.Println("marshal error: ", err)
			return
		}
		network.Send(player.sockIndex, jd)
	}
	go fight()
}

func processFrame(data *json.RawMessage) {
	// frameReadyCount++
	wg.Wait()
	wg.Add(1)
	frames = append(frames, data)
	wg.Done()
	// if len(frames) < max_player_count {
	// 	return
	// }

	// for _, player := range players {
	// 	js := protoFrame{
	// 		MsgType: "frame",
	// 		Data:    frames,
	// 	}
	// 	jd, err := json.Marshal(js)
	// 	if err != nil {
	// 		fmt.Println("marshal error: ", err)
	// 		return
	// 	}
	// 	network.Send(player.sockIndex, jd)
	// }

	// frames = make([]*json.RawMessage, 0)
	// frameNo++
	// frameReadyCount = 0
}

func fight() {
	for {
		wg.Wait()
		wg.Add(1)
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
			fmt.Println("send data")
		}
		frames = make([]*json.RawMessage, 0)
		frameNo++
		wg.Done()
		time.Sleep(20 * time.Millisecond)
	}
}

func Start() {
	fmt.Println("battle start")

	players = make(map[int]*Player)

	go start()
}
