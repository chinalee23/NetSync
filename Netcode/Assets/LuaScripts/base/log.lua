local _error = error
local _print = print

local function traceback( ... )
	return '\n' .. debug.traceback('lua traceback', 3)
end

local function dump_table( tbl )
	local out = {}
	local write = function ( value )
		out[#out + 1] = value
	end

	local indent = 0
	local format
	format = function ( write, msg, indent )
		for k, v in pairs(msg) do
			write(string.rep(' ', indent))
			if type(v) == 'table' then
				write(tostring(k) .. ': {\n')
				format(write, v, indent + 4)
				write(string.rep(' ', indent))
				write('}\n')
			else
				write(string.format('%s: %s\n', tostring(k), tostring(v)))
			end
		end
	end

	format(write, tbl, 0)
	return table.concat(out)
end

local function output( func, t, ... )
	local out
	if type(t) == 'table' then
		out = dump_table(t)
	else
		local msg = {t, ...}
		for i = 1, #msg do
			msg[i] = tostring(msg[i])
		end
		out = table.concat(msg, '|')
	end

	func(out .. traceback())
end

local function info( t, ... )
	output(_print, t, ...)
end

local function error( t, ... )
	output(_error, t, ...)
end

log = {
	info = info,
	error = error,
}