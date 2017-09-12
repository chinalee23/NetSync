module('game')


local function onEnterRsp(msg)
	playerId = msg.playerId
end
NET.addListener('enterRsp', onEnterRsp)

remotePlayers = {}
local function onEnterNotice(msg)
	table.insert(remotePlayers, msg.playerId)
end
NET.addListener('enterNotice', onEnterNotice)

local function onBattleStart( ... )
	LuaInterface.LoadScene('NetTest')
end
NET.addListener('battleStart', onBattleStart)


local upfuncs = {}
function addUpdate(func)
	if not upfuncs[func] then
		upfuncs[func] = true
	end
end

local fixedUpfuncs = {}
function addFixedupdate(func)
	if not fixedUpfuncs[func] then
		fixedUpfuncs[func] = true
	end
end

function update( ... )
	for k, _ in pairs(upfuncs) do
		k()
	end
end

function fixedUpdate( ... )
	for k, _ in pairs(fixedUpfuncs) do
		k()
	end
end

function processMsg(msg)
	NET.receive(msg)
end

return {
	update = update,
	fixedUpdate = fixedUpdate,
	processMsg = processMsg,
}