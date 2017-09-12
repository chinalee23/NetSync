module('Util.Command')

function clear(command)
	command.up = false
	command.down = false
	command.left = false
	command.right = false
end