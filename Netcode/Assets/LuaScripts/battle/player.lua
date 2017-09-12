local _M = setmetatable({}, {__index = _G})
setfenv(1, _M)

function _M:ctor(id)
	self.playerId = id

	self.entity = nil
end

return _M