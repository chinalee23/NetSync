local _M = setmetatable({}, {__index = _G})
setfenv(1, _M)

local speed = 10
local interval = 0.02


function fixedUpdate( ... )
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

return _M