local _M = setmetatable({}, {__index = _G})
setfenv(1, _M)

local speed = 50
local interval = 0.02


function _fixedUpdate( ... )
	local dist = speed * interval

	local entities = Battle.World.getEntities({
		'Command',
		'Transform',
	})

	for _, entity in ipairs(entities) do
		local command = entity.components.Command

		local offset
		local rotation
		if command.up then
			offset = vector3.new(0, 0, 1)
			rotation = vector3.new(0, 0, 0)
		elseif command.down then
			offset = vector3.new(0, 0, -1)
			rotation = vector3.new(0, 180, 0)
		elseif command.left then
			offset = vector3.new(-1, 0, 0)
			rotation = vector3.new(0, 270, 0)
		elseif command.right then
			offset = vector3.new(1, 0, 0)
			rotation = vector3.new(0, 90, 0)
		else
			offset = vector3.new(0, 0, 0)
			animName = 'idle'
		end

		local trans = entity.components.Transform
		trans.position = trans.position + (offset * dist)
		trans.rotation = rotation or trans.rotation
	end
end

function _update( ... )
	local entity = Battle.World.getEntityFromPlayerId(game.playerId)
	local trans = entity.components.Transform

	LuaInterface.SetRotationByEuler(trans.handle, trans.rotation.x, trans.rotation.y, trans.rotation.z)

	LuaInterface.SetScale(trans.handle, trans.scale.x, trans.scale.y, trans.scale.z)

	local dist = trans.position:dist(trans.destination)
	if dist < 0.01 then
		trans.postion = trans.destination
	else
		trans.position:lerp(trans.position, trans.destination, Time.deltaTime / 0.02)
	end

	LuaInterface.SetPosition(trans.handle, trans.position.x, trans.position.y, trans.position.z)
end

function fixedUpdate( ... )
	local entities = Battle.World.getEntities({
		'Transform',
	})

	local dist = speed * interval
	local commands = Singleton.Command.commands
	for _, entity in ipairs(entities) do
		local command = commands[entity.id]
		if command then
			local offset
			local rotation 
			local direction = command.direction
			if direction == 'up' then
				offset = vector3.new(0, 0, 1)
				rotation = vector3.new(0, 0, 0)
			elseif direction == 'down' then
				offset = vector3.new(0, 0, -1)
				rotation = vector3.new(0, 180, 0)
			elseif direction == 'left' then
				offset = vector3.new(-1, 0, 0)
				rotation = vector3.new(0, 270, 0)
			elseif direction == 'right' then
				offset = vector3.new(1, 0, 0)
				rotation = vector3.new(0, 90, 0)
			else
				offset = vector3.new(0, 0, 0)
			end
			
			local trans = entity.components.Transform
			-- trans.destination = trans.destination + (offset * dist)
			trans.position = trans.position + (offset * dist)
			trans.rotation = rotation or trans.rotation
		end
	end
end

return _M