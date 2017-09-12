function instance(p, ...)
	local t = {}
	for k, v in pairs(p) do
		if type(v) == 'table' then
			t[k] = {}
		end
	end
	setmetatable(t, {__index = p})

	if p.ctor then
		t:ctor(...)
	end

	return t
end