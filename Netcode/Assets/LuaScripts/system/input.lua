local _M = setmetatable({}, {__index = _G})
setfenv(1, _M)

local Input = CS.UnityEngine.Input
local KeyCode = CS.UnityEngine.KeyCode
local input = Singleton.Input

function update( ... )
	if Input.GetKeyDown(KeyCode.W) then
		input.key_W = true
	elseif Input.GetKeyUp(KeyCode.W) then
		input.key_W = false
	end

	if Input.GetKeyDown(KeyCode.S) then
		input.key_S = true
	elseif Input.GetKeyUp(KeyCode.S) then
		input.key_S = false
	end

	if Input.GetKeyDown(KeyCode.A) then
		input.key_A = true
	elseif Input.GetKeyUp(KeyCode.A) then
		input.key_A = false
	end

	if Input.GetKeyDown(KeyCode.D) then
		input.key_D = true
	elseif Input.GetKeyUp(KeyCode.D) then
		input.key_D = false
	end
end

return _M