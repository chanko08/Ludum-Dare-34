local Wall       = require 'entities.wall'
local Barrier    = require 'entities.barrier'
local Coin       = require 'entities.coin'
local TestTurret = require 'entities.test_turret'
local SpinnerTurret = require 'entities.spinner_turret'
local RapidTurret   = require 'entities.rapid_turret'

local LevelGenerator = tiny.processingSystem()

LevelGenerator.filter = tiny.requireAll('is_player')

-- local function rand(lo,hi)
-- 	return lo + math.random()*(hi - lo)
-- end

local function reset_boolean(thing,bool_name) 
    return function()
        thing[bool_name] = true
    end
end



function LevelGenerator:process(entity, dt)
	entity.level.time = entity.level.time + dt
    
    if entity.level.create_rapid then
		entity.level.create_rapid = false

		local x = love.window.getWidth()+80
		local y = math.rand(100, love.window.getHeight() - 100)

		tiny.addEntity(ecs, RapidTurret.new(x,y))

		local type_max = 30
		local start_time = math.max(200/(entity.level.time + 40), 1)
		local end_time   = math.min(200/entity.level.time, type_max)
		Timer.after( math.rand(start_time, end_time), reset_boolean(entity.level, 'create_rapid') )
		

		--Timer.after( math.rand(1,3), reset_boolean(entity.level, 'create_rapid') )
	end

	if entity.level.create_turret then
		entity.level.create_turret = false

		local x = love.window.getWidth()+250
		local y = math.rand(100, love.window.getHeight() - 100)

		tiny.addEntity(ecs, TestTurret.new(x,y))
		local type_max = 10
		local start_time = math.max(200/(entity.level.time + 40), 1)
		local end_time   = math.min(200/entity.level.time, type_max)
		Timer.after( math.rand(start_time, end_time), reset_boolean(entity.level, 'create_turret') )
		-- Timer.after( math.rand(2,4), reset_boolean(entity.level, 'create_turret') )
	end

	if entity.level.create_spinner then
		entity.level.create_spinner = false

		local x = love.window.getWidth()+40
		local y = math.rand(100, love.window.getHeight() - 100)

		tiny.addEntity(ecs, SpinnerTurret.new(x,y))
		local type_max = 60
		local start_time = math.max(200/(entity.level.time + 40), 1)
		local end_time   = math.min(200/entity.level.time, type_max)
		Timer.after( math.rand(start_time, end_time), reset_boolean(entity.level, 'create_spinner') )
		-- Timer.after( math.rand(4,10), reset_boolean(entity.level, 'create_spinner') )
	end

	

	if entity.level.create_coins then
		entity.level.create_coins = false

		local nx_coins = math.floor(math.rand(10,31))
		local ny_coins = math.floor(math.rand(3,7))

		local start_x = love.window.getWidth()+20

		local start_y = math.rand(.2,.8)*love.window.getHeight()
		local end_y   = start_y + math.rand(-50,50)

		for i=1,ny_coins do
			for j=1,nx_coins do
				tiny.addEntity(ecs, Coin.new(start_x + 25*j, start_y + j*(end_y-start_y)/nx_coins + 25*i, 10))
			end
		end
		local type_max = 30
		local start_time = math.max(200/(entity.level.time + 40), 1)
		local end_time   = math.min(200/entity.level.time, type_max)
		Timer.after( math.rand(start_time, end_time), reset_boolean(entity.level, 'create_coins') )
		-- Timer.after( math.rand(3,10), reset_boolean(entity.level, 'create_coins') )
	end
end

return LevelGenerator