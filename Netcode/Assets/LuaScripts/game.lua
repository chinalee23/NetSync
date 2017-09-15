module('game')

local json = require 'dkjson'

isOnline = true

local function onEnterRsp(msg)
	playerId = msg.playerId
	log.info('my playerId', playerId)
end
NET.addListener('enterRsp', onEnterRsp)

remotePlayers = {}
local function onBattleStart(msg)
	for _, v in ipairs(msg.playerIds) do
		if v ~= game.playerId then
			table.insert(remotePlayers, v)
		end
	end
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

local function update( ... )
	for k, _ in pairs(upfuncs) do
		k()
	end
end

local function fixedUpdate( ... )
	for k, _ in pairs(fixedUpfuncs) do
		k()
	end
end

local function processMsg(msg)
	NET.receive(msg)
end

function start( ... )
	if isOnline then
		LuaInterface.Connect()
		local jd = json.encode({
			msgType = 'enter',
		})
		NET.send(jd)
	else
		playerId = 1
		-- table.insert(remotePlayers, 101)
		LuaInterface.LoadScene('NetTest')
	end
end

return {
	update = update,
	fixedUpdate = fixedUpdate,
	processMsg = processMsg,
	start = start,
}