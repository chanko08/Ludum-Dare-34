local Wall       = require 'entities.wall'
local Barrier    = require 'entities.barrier'
local TestTurret = require 'entities.test_turret'

local LevelGenerator = tiny.processingSystem()

LevelGenerator.filter = tiny.requireAll('is_player')

local function rand(lo,hi)
	return lo + math.random()*(hi - lo)
end

local function reset_boolean(thing,bool_name) 
    return function()
        thing[bool_name] = true
    end
end

function LevelGenerator:process(entity, dt)
    
	if entity.level.create_turret then
		entity.level.create_turret = false

		local x = love.window.getWidth()+250
		local y = rand(100, love.window.getHeight() - 100)

		tiny.addEntity(ecs, TestTurret.new(x,y))

		Timer.after( rand(0,3), reset_boolean(entity.level, 'create_turret') )
	end

	if entity.level.create_obstacle then
		entity.level.create_obstacle = false

		if rand(0,1) < 0.5 then
			-- regular barrier of random height
			local h = rand(.2,.6)*love.window.getHeight()
			local w = rand(10,100)

			local x = love.window.getWidth() + 5
			local y = rand(10, love.window.getHeight() - h)

			tiny.addEntity(ecs, Barrier.new(x,y,w,h))
		else
			-- make a "hole" obstacle
			-- regular hole of random height
			local hole_h = rand(.2,.6)*love.window.getHeight()
			local hole_w = rand(10,100)

			local x = love.window.getWidth() + 5
			local hole_y = rand(10, love.window.getHeight() - hole_h)

			tiny.addEntity(ecs, Barrier.new(x,0, x+hole_w, hole_y))
			tiny.addEntity(ecs, Barrier.new(x, hole_y + hole_h, x+hole_w, love.window.getHeight()))
		end

		Timer.after( rand(10,20), reset_boolean(entity.level, 'create_obstacle') )
	end

end

return LevelGenerator