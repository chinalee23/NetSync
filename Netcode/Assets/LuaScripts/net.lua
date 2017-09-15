module('NET', package.seeall)

local json = require 'dkjson'


local listener = {}
function addListener(type, callback)
	listener[type] = listener[type] or {}
	table.insert(listener[type], callback)
end

function receive(msg)
	jd = json.decode(msg, 1, nil)

	-- log.info('receive msg', jd.msgType)
	if listener[jd.msgType] then
		for _, cb in ipairs(listener[jd.msgType]) do
			cb(jd)
		end
	end
end

function send(msg)
	LuaInterface.SendMsg(msg)
end
