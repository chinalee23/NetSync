module('Battle.World')

local started = false
local frame = 0

local remotePlayers = {}

local systems = {}
local systemList = {
	'system.input',
	'system.command',
	'system.player',
	'system.camera',
	'system.behavior',
}

local function onEnterRsp(msg)
	playerId = msg.playerId
end
NET.addListener('enterRsp', onEnterRsp)

local function onEnterNotice(msg)
	table.insert(remotePlayers, msg.playerId)
end
NET.addListener('enterNotice', onEnterNotice)

local function init( ... )
	require 'entity.entity'

	require 'singleton.camera'
	require 'singleton.input'

	require 'Component.Command'
	require 'Component.Controllable'
	require 'Component.Transform'

	require 'util.command'
end

local entities = {}
local function initEntity( ... )
	local player = require 'battle.player'

	-- me
	local me = instance(player, playerId)
	local entity = instance(Entity)
	local goMe = ResourcesMgr.LoadPrefab('Characters/16011002_Diffuse_Prefab')
	goMe.name = 'me'

	local trans = entity:addComponent(Component.Transform, goMe.transform)
	trans.scale:set(3, 3, 3)
	trans.position:set(0, 0, 0)

	entity:addComponent(Component.Controllable)
	entity:addComponent(Component.Command)
	entities[entity.id] = entity

	player.entity = entity

	-- enemy
	for _, v in ipairs(remotePlayers) do
		local enemy = instance(player, v)

		local entity = instance(Entity)
		local goEnemy = ResourcesMgr.LoadPrefab('Characters/16011002_Diffuse_Prefab')
		goEnemy.name = 'enemy' .. v

		local trans = entity:addComponent(Component.Transform, goEnemy.transform)
		trans.scale:set(4, 4, 4)
		trans.position:set(20, 0, 20)

		entity:addComponent(Component.Command)
		entities[entity.id] = entity
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

local function fixedUpdate( ... )
	if not started then return end
	
	frame = frame + 1
	for _, system in ipairs(systems) do
		if system.fixedUpdate then
			system.fixedUpdate()
		end
	end
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
			rtn[entity.id] = entity
		end
	end

	return rtn
end

function getEntity(id)
	return entities[id]
end

function buildWorld( ... )
	init()

	initSingleton()
	initEntity()
	initSystem()

	game.addUpdate(update)
	game.addFixedupdate(fixedUpdate)
end

function start( ... )
	log.info('battle start')
	started = true
end

isOnline = true