package main

import (
	"battle"
	"glua"
	"network"
	"time"
)

func main() {
	glua.Start()
	network.Start()
	battle.Start()
	for {
		time.Sleep(1 * time.Second)
	}
}
