module('System.Input')

local json = require 'dkjson'

local Input = CS.UnityEngine.Input
local KeyCode = CS.UnityEngine.KeyCode
local input = Singleton.Input

local function genCommand( ... )
	local command = {}
	if input.key_up then
		command.direction = 'up'
	elseif input.key_down then
		command.direction = 'down'
	elseif input.key_left then
		command.direction = 'left'
	elseif input.key_right then
		command.direction = 'right'
	end

	input.key_up = false
	input.key_down = false
	input.key_left = false
	input.key_right = false
	
	return command
end

local function sendCommand(command)
	local jd = json.encode({
		msgType = 'frame',
		data = {
			playerId = game.playerId,
			command = command,
		}
	})

	NET.send(jd)

	Battle.World.readyForNextFrame = false
end

local function saveCommand(command)
	local entity = Battle.World.getEntityFromPlayerId(game.playerId)
	Singleton.Command.commands[entity.id] = command
end

function update( ... )
	if Input.GetKey(KeyCode.W) then
		input.key_up = true
	elseif Input.GetKey(KeyCode.S) then
		input.key_down = true
	elseif Input.GetKey(KeyCode.A) then
		input.key_left = true
	elseif Input.GetKey(KeyCode.D) then
		input.key_right = true
	end
end

function handleInput( ... )
	local command = genCommand()
	if game.isOnline then
		sendCommand(command)
	else
		saveCommand(command)
	end
end

function recvInput(msg)
	local commands = Singleton.Command.commands
	for _, v in ipairs(msg.data) do
		local entity = Battle.World.getEntityFromPlayerId(v.playerId)
		commands[entity.id] = {direction = v.command.direction}
	end
end

return _M