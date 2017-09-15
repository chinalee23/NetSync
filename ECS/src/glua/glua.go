package glua

import (
	"fmt"
	"github.com/yuin/gopher-lua"
	"os"
	"path/filepath"
	"time"
)

var L *lua.LState
var ltEntry *lua.LTable

func loadLua(path string) bool {
	currDir, err := filepath.Abs(filepath.Dir(os.Args[0]))
	if err != nil {
		fmt.Println("error: ", err)
		return false
	}
	currDir += "/../src/glua/script/" + path
	if err := L.DoFile(currDir); err != nil {
		fmt.Println("lua error: ", err)
		return false
	}
	return true
}

func callLua(lf lua.LValue, args ...lua.LValue) []lua.LValue {
	L.Push(lf)
	for _, arg := range args {
		L.Push(arg)
	}
	oldTop := L.GetTop()
	L.PCall(len(args), -1, nil)
	newTop := L.GetTop()
	rtns := make([]lua.LValue, 0)
	for i := oldTop; i <= newTop; i++ {
		lv := L.Get(i)
		rtns = append(rtns, lv)
	}
	return rtns
}

func test(L *lua.LState) int {
	fmt.Println("go.test")
	return 0
}

func Start() {
	L = lua.NewState()
	if !loadLua("bootstrap.lua") {
		return
	}

	ltEntry = L.ToTable(-1)
	if ltEntry == nil {
		fmt.Println("get table fail")
		return
	}

	lfUpdate := ltEntry.RawGetString("update")
	callLua(lfUpdate)

	ltEntry.RawSetString("test", L.NewFunction(test))
	lfCallGO := ltEntry.RawGetString("callGO")
	callLua(lfCallGO)
}

func update() {
	for {
		if err := L.CallByParam(lua.P{
			Fn:      ltEntry.RawGetString("update"),
			Protect: true,
		}); err != nil {
			fmt.Println("call error: ", err)
		}

		time.Sleep(100 * time.Millisecond)
	}
}
