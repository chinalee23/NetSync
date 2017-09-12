module('Util.Transform')

function SetPosition(handle, position)
	handle.position = CS.UnityEngine.Vector3(position[1], position[2], position[3])
end