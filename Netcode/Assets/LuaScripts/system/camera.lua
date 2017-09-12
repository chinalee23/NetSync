local _M = setmetatable({}, {__index = _G})
setfenv(1, _M)

local camera = Singleton.Camera
function update( ... )
	local entity = Battle.World.getEntities({
		'Controllable',
		'Transform',
	})[1]
	local trans = entity.components.Transform
	local pos = trans.position + camera.offset
	LuaInterface.SetPosition(camera.handle, pos.x, pos.y, pos.z)
end

game.addUpdate(update)

return _M