package main

import (
	"battle"
	"network"
	"time"
)

func main() {
	network.Start()
	battle.Start()
	for {
		time.Sleep(1 * time.Second)
	}
}
