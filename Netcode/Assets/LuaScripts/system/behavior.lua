local _M = setmetatable({}, {__index = _G})
setfenv(1, _M)

local function setTransform( ... )
	local entities = Battle.World.getEntities({
		'Transform',
	})

	for _, entity in pairs(entities) do
		local trans = entity.components.Transform

		local pos = trans.position
		LuaInterface.SetPosition(trans.handle, pos.x, pos.y, pos.z)

		local scale = trans.scale
		LuaInterface.SetScale(trans.handle, scale.x, scale.y, scale.z)

		local rotation = trans.rotation
		LuaInterface.SetRotationByEuler(trans.handle, rotation.x, rotation.y, rotation.z)
	end
end

function fixedUpdate( ... )
	setTransform()
end

function init( ... )
	setTransform()
end

return _M