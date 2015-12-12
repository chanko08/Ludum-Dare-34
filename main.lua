inspect    = require 'lib.inspect'
GameState  = require 'lib.hump.gamestate'
HumpCamera = require 'lib.hump.camera'
Vector     = require 'lib.hump.vector'
class      = require 'lib.hump.class'
Timer      = require 'lib.hump.timer'
anim8      = require 'lib.anim8'
bump       = require 'lib.bump'
tiny       = require 'lib.tiny'
_          = require 'lib.underscore'

local BBoxRenderer = require 'renderers.bbox'
local PhysicsSystem = require 'systems.physics'
local JumpSystem = require 'systems.jump'
local ShootSystem = require 'systems.shoot'

local Player = require 'entities.player'


ecs     = tiny.world()
world   = bump.newWorld()

pause = false

JUMP_KEY  = 'lctrl'
SHOOT_KEY = 'rctrl'

change_state = false
function switch_state(st, ...)
    change_state = {}
    change_state.state = st
    change_state.args = {...}
end

function refresh_state()
    ecs   = tiny.world()
    world = bump.newWorld()
end


function game_state()
    tiny.addSystem(ecs, BBoxRenderer)
    tiny.addSystem(ecs, JumpSystem)
    tiny.addSystem(ecs, PhysicsSystem)
    tiny.addSystem(ecs, ShootSystem)

    

    local player = Player.new()

    tiny.addEntity(ecs, player)
end

function menu_state()
    -- 
end

function win_state()
    -- 
end

function lose_state()
    -- 
end


function love.load()
    refresh_state()
    game_state()
end


function love.update(dt)
    if change_state then
        state_refresh()
        change_state.state(unpack(change_state.args))
        change_state = nil
    end

        
    if not pause then

        tiny.update(ecs, dt, tiny.rejectAny('draw'))
        Timer.update(dt)
    end
end

function love.draw()
    tiny.update(ecs, 0, tiny.requireAll('draw'))
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end
    if key=='p' then
        pause = not pause
    end
    tiny.update(ecs, {key=key, isDown=true}, tiny.requireAll('keyboard'))
end

function love.keyreleased(key)
    tiny.update(ecs, {key=key, isDown=false}, tiny.requireAll('keyboard'))
end
