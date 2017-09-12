local json = require 'dkjson'

function awake( ... )
	
end

function start( ... )
	Battle.World.buildWorld()

	Singleton.Camera.handle = camera

	local pos = camera.transform.position
	Singleton.Camera.offset = vector3.new(pos.x, pos.y, pos.z)

	if Battle.World.isOnline then
		LuaInterface.Connect()
		local jd = json.encode({
			msgType = 'enter'
		})
		NET.send(jd)
	else
		Battle.World.start()
	end
end

function update( ... )
	
end
