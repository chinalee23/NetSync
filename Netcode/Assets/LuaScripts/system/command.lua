local _M = setmetatable({}, {__index = _G})
setfenv(1, _M)

local json = require 'dkjson'

local input = Singleton.Input

local function genCommand()
	local command = {}
	if input.key_Up then
		command.direction = 'up'
	elseif input.key_S then
		command.direction = 'down'
	elseif input.key_A then
		command.direction = 'left'
	elseif input.key_D then
		command.direction = 'right'
	end
	return command
end

local function sendCommand( ... )
	local command = genCommand()
	local jd = json.encode({
		msgType = 'frame',
		data = {
			playerId = game.playerId,
			command = genCommand(),
		}
	})

	NET.send(jd)

	Battle.World.readyForNextFrame = false
end

local function saveCommand( ... )
	local entity = Battle.World.getEntityFromPlayerId(game.playerId)
	Singleton.Command.commands[entity.id] = genCommand()
end

function fixedUpdate( ... )
	if game.isOnline then
		sendCommand()
	else
		saveCommand()
	end
end


return _M