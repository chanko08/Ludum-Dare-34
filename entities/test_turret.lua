local SplitterItem = require 'entities.splitter_item'
local PulserItem = require 'entities.pulser_item'
local RapidItem = require 'entities.rapid_item'
local HealthItem = require 'entities.health_item'


local TURRET_PIC   = love.graphics.newImage('assets/img/turret_sheet.png')
local TURRET_GRID  = anim8.newGrid(100, 100, TURRET_PIC:getWidth(), TURRET_PIC:getHeight())

local TURRET_BULLET_PIC = love.graphics.newImage('assets/img/bullet2b_sheet.png')
local TURRET_BULLET_GRID = anim8.newGrid(12, 12, TURRET_BULLET_PIC:getWidth(), TURRET_BULLET_PIC:getHeight())


local TestTurret = {}
function TestTurret.new( left, top )
    local turret = {}
    turret.x = left
    turret.y = top
    turret.w = 100
    turret.h = 100
    turret.color = {255, 255, 0}
    turret.health = 1
    turret.fire_animation = anim8.newAnimation(TURRET_GRID('1-5',1), 1/5.0)
    turret.fire_animation:gotoFrame(4)
    turret.animation = turret.fire_animation
    turret.image = TURRET_PIC
    turret.die_callback = function()
        if math.random() <= 0.8 then
            if math.random() <= 0.8 then
                tiny.addEntity(ecs, PulserItem.new(turret.x + turret.w / 2, turret.y + turret.h / 2))                 
            else
                tiny.addEntity(ecs, HealthItem.new(turret.x + turret.w / 2, turret.y + turret.h / 2))
            end         
        end
    end

    turret.vx = -60
    turret.vy = 0
    turret.is_enemy = true
    turret.is_test_turret = true
    turret.collision = {}
    turret.collision.filter =  function() return 'cross' end
    turret.collision.callback = function(col) end

    local gun = {}
    gun.ready = true
    gun.fire_delay = 2
    gun.create_bullet = function(turret)
        local bullet = {}
        bullet.x = turret.x - 10
        bullet.y = turret.y + turret.h / 2
        bullet.vx = -500
        bullet.vy = 0

        bullet.w = 12
        bullet.h = 12

        bullet.move_animation = anim8.newAnimation(TURRET_BULLET_GRID('1-2',1), 0.3)
        bullet.explode_animation = anim8.newAnimation(TURRET_BULLET_GRID(3,1), 0.2)
        bullet.animation = bullet.move_animation
        bullet.image = TURRET_BULLET_PIC

        bullet.damage = 20
        bullet.is_bullet = true

        bullet.collision = {}
        bullet.collision.filter = function(item, other)
            local filter = {}
            filter.is_player = 'touch'
            filter.is_ground = 'cross'
            filter.is_item   = 'cross'
            filter.is_enemy  = 'cross'
            filter.is_bullet = 'cross'

            for tag_name, resolution_type in pairs(filter) do
                if other[tag_name] then
                    return resolution_type
                end
            end

            --default to slide mechanics
            return 'slide'
        end

        bullet.collision.callback = function(col)
            local other = col.other
            local bullet = col.item
            
            if other.is_player and not col.item.is_exploded then
                other.health = other.health - bullet.damage
                col.item.is_exploded = true
                col.item.animation = col.item.explode_animation
                Timer.after(0.05, function() tiny.removeEntity(ecs, col.item) end)
            elseif other.is_ground and not col.item.is_exploded then
                col.item.is_exploded = true
                col.item.animation = col.item.explode_animation 
                Timer.after(0.05, function() tiny.removeEntity(ecs, col.item) end)
            end
        end

        bullet.color = {0, 255, 255 }
        tiny.addEntity(ecs, bullet)
    end

    turret.gun = gun

    return turret
end

return TestTurret