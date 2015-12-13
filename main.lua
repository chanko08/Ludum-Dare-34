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

math.rand = function(lo,hi)
    return lo + math.random()*(hi - lo)
end


local BBoxRenderer = require 'renderers.bbox'
local ControlSelectionRenderer = require 'renderers.control_selection'
local HudRenderer = require 'renderers.hud'

local LevelGenerator = require 'systems.level_generator'
local PhysicsSystem = require 'systems.physics'
local FlySystem = require 'systems.fly'
local ShootSystem = require 'systems.shoot'
local HealthSystem = require 'systems.health'
local CleanSystem  = require 'systems.clean'
local ControlSelectionSystem = require 'systems.control_selection'
local PulseBulletSystem = require 'systems.pulse_bullet'


local TestTurretAI = require 'systems.ai.test_turret'
local SpinnerTurretAI = require 'systems.ai.spinner_turret'

local Player = require 'entities.player'
local Wall   = require 'entities.wall'
local TestTurret = require 'entities.test_turret'


ecs     = tiny.world()
world   = bump.newWorld()

pause = false

JUMP_KEY  = 'lshift'
SHOOT_KEY = 'rshift'

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


function game_state(controls)
    tiny.addSystem(ecs, HudRenderer)
    tiny.addSystem(ecs, BBoxRenderer)
    tiny.addSystem(ecs, FlySystem)
    tiny.addSystem(ecs, PhysicsSystem)
    tiny.addSystem(ecs, ShootSystem)
    tiny.addSystem(ecs, HealthSystem)
    tiny.addSystem(ecs, TestTurretAI)
    tiny.addSystem(ecs, SpinnerTurretAI)
    tiny.addSystem(ecs, LevelGenerator)
    tiny.addSystem(ecs, CleanSystem)
    tiny.addSystem(ecs, PulseBulletSystem)
    


    local player = Player.new(controls)
    local ground = Wall.new(-5, love.window.getHeight() - 10, love.window.getWidth(), 20)
    local ceiling = Wall.new(-5, -20, love.window.getWidth(), 20)
    local turret = TestTurret.new(400, 250)

    tiny.addEntity(ecs, player)
    tiny.addEntity(ecs, player.gun)
    tiny.addEntity(ecs, ground)
    tiny.addEntity(ecs, ceiling)
    tiny.addEntity(ecs, turret)
end

function menu_state()
    tiny.addSystem(ecs, ControlSelectionSystem)
    tiny.addSystem(ecs, ControlSelectionRenderer)

    local game_control = {}
    game_control.is_control_selection = true


    tiny.addEntity(ecs, game_control)
end

function win_state()
    -- 
end

function lose_state()
    -- 
end


function love.load()
    refresh_state()
    menu_state()
    --game_state()
end


function love.update(dt)
    if change_state then
        refresh_state()
        change_state.state(unpack(change_state.args))
        change_state = nil
    end

        
    if not pause then

        tiny.update(ecs, dt, tiny.rejectAny('draw', 'keyboard'))
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
