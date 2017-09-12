function module(name)
	local s = string.split(name, '.')
	local t = _G
	for i = 1, #s do
		if not t[s[i]] then
			t[s[i]] = {}
		end
		t = t[s[i]]
	end

	setmetatable(t, {__index = _G})
	setfenv(2, t)

	_M = t

	return t
end