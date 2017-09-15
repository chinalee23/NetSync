local json = require 'dkjson'

function awake( ... )
	
end

function start( ... )
	Battle.World.buildWorld()

	Singleton.Camera.handle = camera

	local pos = camera.transform.position
	Singleton.Camera.offset = vector3.new(pos.x, pos.y, pos.z)

	Battle.World.start()
end

function update( ... )
	
end
