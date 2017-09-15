module('Component.Transform')

__name = 'Transform'

function _M:ctor(handle)
	self.position = vector3.new()
	self.rotation = vector3.new()
	self.scale = vector3.new()
	self.destination = vector3.new()

	self.handle = handle
end