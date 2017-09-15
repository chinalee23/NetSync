module('Battle.World')

local json = require 'dkjson'

local started = false
frame = 0

local systems = {}
local systemList = {
	'system.input',
	-- 'system.command',
	'system.player',
	'system.camera',
	'system.behavior',
}

local function init( ... )
	require 'entity.entity'

	require 'singleton.player'
	require 'singleton.camera'
	require 'singleton.input'
	require 'singleton.command'

	require 'Component.Command'
	require 'Component.Controllable'
	require 'Component.Transform'

	require 'util.command'
end

local entities = {}
local playerToEntity = {}
local function initEntity( ... )
	-- me
	local entity = instance(Entity)
	local go = ResourcesMgr.LoadPrefab('Characters/16011002_Diffuse_Prefab')
	go.name = 'me'

	local trans = entity:addComponent(Component.Transform, go.transform)
	trans.scale:set(3, 3, 3)
	trans.position:set(0, 0, 0)
	trans.rotation:set(0, 0, 0)
	entities[entity.id] = entity
	playerToEntity[game.playerId] = entity

	-- enemy
	for _, v in ipairs(game.remotePlayers) do
		local entity = instance(Entity)
		local goEnemy = ResourcesMgr.LoadPrefab('Characters/16011002_Diffuse_Prefab')
		goEnemy.name = 'enemy' .. v

		local trans = entity:addComponent(Component.Transform, goEnemy.transform)
		trans.scale:set(4, 4, 4)
		trans.position:set(20, 0, 20)
		trans.rotation:set(0, 0, 0)

		entity:addComponent(Component.Command)
		entities[entity.id] = entity
		playerToEntity[v] = entity
	end
end

local function initSystem( ... )
	systems = {}
	for _, v in ipairs(systemList) do
		local system = require(v)
		if system.init then
			system.init()
		end
		table.insert(systems, system)
	end
end

local function update( ... )
	for _, system in ipairs(systems) do
		if system.update then
			system.update()
		end
	end
end

local function goOneRound( ... )
	for _, system in ipairs(systems) do
		if system.fixedUpdate then
			system.fixedUpdate()
		end
	end

	Singleton.Command.commands = {}
end

readyForNextFrame = true
local function fixedUpdate( ... )
	if not started then return end

	if not readyForNextFrame then return end

	frame = frame + 1

	System.Input.handleInput()

	if not game.isOnline then goOneRound() end
end

function getTuples(concerned)
	local rtn = {}
	local concernedCnt = #concerned
	for _, entity in ipairs(entities) do
		local t = {}
		local len = 0
		for _, v in ipairs(concerned) do
			local com = entity.components[v]
			if v then
				t[v] = com
				len = len + 1
			else
				break
			end
		end
		if len == concernedCnt then
			table.insert(rtn, t)
		end
	end
	
	return rtn
end

function getEntities(concerned)
	local rtn = {}
	local concernedCnt = #concerned
	for _, entity in pairs(entities) do
		local flag = true
		for _, com in ipairs(concerned) do
			if not entity.components[com] then
				flag = false
				break
			end
		end
		if flag then
			table.insert(rtn, entity)
		end
	end

	return rtn
end

function getEntityFromPlayerId(id)
	return playerToEntity[id]
end

function buildWorld( ... )
	init()
	
	initEntity()
	initSystem()

	game.addUpdate(update)
	game.addFixedupdate(fixedUpdate)
end

local function fight( ... )
	log.info('fight')
	started = true
end
NET.addListener('fight', fight)

function start( ... )
	if game.isOnline then
		local jd = json.encode({
			msgType = 'ready'
		})
		NET.send(jd)
	else
		fight()
	end
end



local function onFrame(msg)
	System.Input.recvInput(msg)

	goOneRound()

	readyForNextFrame = true
end
NET.addListener('frame', onFrame)
