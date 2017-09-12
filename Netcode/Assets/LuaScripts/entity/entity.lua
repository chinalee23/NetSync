module('Entity')

local id = 0
function _M:ctor()
	id = id + 1
	self.id = id
	self.components = {}
end

function _M:addComponent(com, ...)
	local t = instance(com, ...)
	self.components[com.__name] = t
	return t
end