local _M = setmetatable({}, {__index = _G})
setfenv(1, _M)

local input = Singleton.Input

local function onFrame(msg)
	for _, v in ipairs(msg.data) do
		local direction = v.command.direction
		if direction == 'up' then
			command.up = true
		elseif direction == 'down' then
			command.down = true
		elseif direction == 'left' then
			command.left = true
		elseif direction == 'right' then
			command.right = true
		end
	end
end
NET.addListener('frame', onFrame)

local function sendCommand( ... )
	local command = {}
	if input.key_W then
		command.direction = 'up'
	elseif input.key_S then
		command.direction = 'down'
	elseif input.key_A then
		command.direction = 'left'
	elseif imput.key_D then
		command.direction = 'right'
	end
	local jd = json.encode({
		msgType = 'frame',
		data = {
			playerId = 0,
			command = command
		}
	})

	NET.send(jd)
end

local function saveCommand( ... )
	local entity = Battle.World.getEntities({
		'Command',
		'Controllable',
	})[1]
	local command = entity.components.Command
	Util.Command.clear(command)
	if input.key_W then
		command.up = true
	elseif input.key_S then
		command.down = true
	elseif input.key_A then
		command.left = true
	elseif input.key_D then
		command.right = true
	end
end

function fixedUpdate( ... )
	if Battle.World.isOnline then
		sendCommand()
	else
		saveCommand()
	end
end


return _M