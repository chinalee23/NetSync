module('Component.Command')

__name = 'Command'

function _M:ctor( ... )
	self.up = false
	self.down = false
	self.left = false
	self.right = false
end

