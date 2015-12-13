local Wall       = require 'entities.wall'
local Barrier    = require 'entities.barrier'
local Coin       = require 'entities.coin'
local TestTurret = require 'entities.test_turret'
local SpinnerTurret = require 'entities.spinner_turret'

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
    
	if entity.level.create_turret then
		entity.level.create_turret = false

		local x = love.window.getWidth()+250
		local y = math.rand(100, love.window.getHeight() - 100)

		tiny.addEntity(ecs, TestTurret.new(x,y))

		Timer.after( math.rand(0,3), reset_boolean(entity.level, 'create_turret') )
	end

	if entity.level.create_spinner then
		entity.level.create_spinner = false

		local x = love.window.getWidth()+40
		local y = math.rand(100, love.window.getHeight() - 100)

		tiny.addEntity(ecs, SpinnerTurret.new(x,y))

		Timer.after( math.rand(4,10), reset_boolean(entity.level, 'create_spinner') )
	end

	if entity.level.create_obstacle then
		entity.level.create_obstacle = false

		if math.rand(0,1) < 0.5 then
			-- regular barrier of random height
			local h = math.rand(.2,.6)*love.window.getHeight()
			local w = math.rand(10,100)

			local x = love.window.getWidth() + 5
			local y = math.rand(10, love.window.getHeight() - h)

			tiny.addEntity(ecs, Barrier.new(x,y,w,h))
		else
			-- make a "hole" obstacle
			-- regular hole of random height
			local hole_h = math.rand(.2,.6)*love.window.getHeight()
			local hole_w = math.rand(10,100)

			local x = love.window.getWidth() + 5
			local hole_y = math.rand(10, love.window.getHeight() - hole_h)

			tiny.addEntity(ecs, Barrier.new(x,0, hole_w, hole_y))
			tiny.addEntity(ecs, Barrier.new(x, hole_y + hole_h, hole_w, love.window.getHeight()))
		end

		Timer.after( math.rand(2,10), reset_boolean(entity.level, 'create_obstacle') )
	end

	if entity.level.create_coins then
		entity.level.create_coins = false

		local nx_coins = math.floor(math.rand(10,31))
		local ny_coins = math.floor(math.rand(3,7))

		start_x = love.window.getWidth()+20

		start_y = math.rand(.2,.8)*love.window.getHeight()
		end_y   = start_y + math.rand(-50,50)

		for i=1,ny_coins do
			for j=1,nx_coins do
				tiny.addEntity(ecs, Coin.new(start_x + 25*j, start_y + j*(end_y-start_y)/nx_coins + 25*i, 10))
			end
		end

		Timer.after( math.rand(3,10), reset_boolean(entity.level, 'create_coins') )
	end

end

return LevelGenerator