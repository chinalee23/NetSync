local t = {}

function t.update( ... )
	print('t.update')

	return 1, 2
end

function t.callGO( ... )
	t.test()
end

return t