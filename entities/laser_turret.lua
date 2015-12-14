local SplitterItem = require 'entities.splitter_item'
local PulserItem = require 'entities.pulser_item'
local RapidItem = require 'entities.rapid_item'
local RapidGun  = require 'entities.rapid_gun'
local HealthItem = require 'entities.health_item'

local LASER_PIC   = love.graphics.newImage('assets/img/destroyer_sheet.png')
local LASER_GRID  = anim8.newGrid(26, 40, LASER_PIC:getWidth(), LASER_PIC:getHeight())
local LASER_BULLET_PIC = love.graphics.newImage('assets/img/big_bullet_sheet.png')
local LASER_BULLET_GRID = anim8.newGrid(40, 40, LASER_BULLET_PIC:getWidth(), LASER_BULLET_PIC:getHeight())

local LaserTurret = {}
function LaserTurret.new( left, top )
    local turret = {}
    turret.x = left
    turret.y = top
    turret.w = 20
    turret.h = 20
    turret.fire_animation = anim8.newAnimation(LASER_GRID('1-5',1),0.5)
    turret.fire_animation:gotoFrame(4)
    
    turret.animation = turret.fire_animation
    print(turret.animation)
    turret.image = LASER_PIC
    turret.shots = 10
    turret.base_shots = 10
    turret.repeat_shot_reset_delay = 2.5
    turret.resetting = false
    turret.color = {255, 255, 0}
    turret.health = 1
    turret.die_callback = function()
        tiny.addEntity(ecs, PulserItem.new(turret.x + turret.w / 2, turret.y + turret.h / 2))   
    end

    turret.vx = -60
    turret.vy = 0
    turret.is_enemy = true
    turret.is_laser_turret = true
    turret.collision = {}
    turret.collision.filter =  function() return 'cross' end
    turret.collision.callback = function(col) end

    local gun = {}
    gun.ready = true
    gun.fire_delay = 0.25
    gun.create_bullet = function(turret)
        local bullet = {}
        bullet.x = turret.x - 10
        bullet.y = turret.y
        bullet.vx = -1200
        bullet.vy = 0

        bullet.move_animation = anim8.newAnimation(LASER_BULLET_GRID('1-4',1), 0.3)
        bullet.animation = bullet.move_animation
        print(bullet.animation)
        bullet.image = LASER_BULLET_PIC

        bullet.w = 40
        bullet.h = 40


        bullet.damage = 20
        bullet.is_bullet = true

        bullet.collision = {}
        bullet.collision.filter = function(item, other)
            local filter = {}
            filter.is_player = 'cross'
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
                -- col.item.animation = col.item.explode_animation
                Timer.after(0.05, function() tiny.removeEntity(ecs, col.item) end)
            elseif other.is_ground and not col.item.is_exploded then
                col.item.is_exploded = true
                -- col.item.animation = col.item.explode_animation 
                Timer.after(0.05, function() tiny.removeEntity(ecs, col.item) end)
            end
        end

        bullet.color = {0, 255, 100 }
        tiny.addEntity(ecs, bullet)
    end

    turret.gun = gun
    turret.gun = RapidGun.new(RapidGun.new(RapidGun.new(RapidGun.new(RapidGun.new(turret.gun)))))


    return turret
end

return LaserTurret