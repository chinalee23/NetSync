local _M = setmetatable({}, {__index = _G})
setfenv(1, _M)

local camera = Singleton.Camera
function fixedUpdate( ... )
	local entity = Battle.World.getEntityFromPlayerId(game.playerId)
	local trans = entity.components.Transform
	local pos = trans.position + camera.offset
	LuaInterface.SetPosition(camera.handle, pos.x, pos.y, pos.z)
end

-- game.addUpdate(update)
game.addFixedupdate(fixedUpdate)

return _M
