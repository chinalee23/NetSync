local meta = {}

local function new( ... )
	local args = {...}
	local t = {
		x = args[1] or 0,
		y = args[2] or 0,
		z = args[3] or 0,
	}
	setmetatable(t, meta)
	return t
end

function meta.__add(a, b)
	return new(a.x + b.x, a.y + b.y, a.z + b.z)
end

function meta.__mul(a, factor)
	return new(a.x * factor, a.y * factor, a.z * factor)
end

function meta.__equal(a)
	self.x = a.x
	self.y = a.y
	self.z = a.z
end

function meta.__tostring(a)
	log.info('[' .. a.x .. ', ' .. a.y .. ', ' .. a.z .. ' ]')
end

local index_meta = {}
meta.__index = index_meta
function index_meta:set( x, y, z )
	self.x = x
	self.y = y
	self.z = z
end

function index_meta:distSq(a)
	return (self.x - a.x)^2 + (self.y - a.y)^2 + (self.z - a.z)^2
end

function index_meta:dist(a)
	return math.sqrt(self:distSq(a))
end

function index_meta:lerp(from , to, t)
	t = math.max(math.min(t, 1), 0)

	local x = from.x
	self.x = x + (to.x - x) * t
	local y = from.y
	self.y = y + (to.y - y) * t
	local z = from.z
	self.z = z + (to.z - z) * t
end

vector3 = {
	new = new,
}


-- local t1 = vector3.new(1,1,1)
-- local t2 = vector3.new(2,2,2)

-- local dist = t1:dist(t2)
-- print(dist)