local SplitterItem = require 'entities.splitter_item'
local PulserItem = require 'entities.pulser_item'
local RapidItem = require 'entities.rapid_item'
local RapidGun  = require 'entities.rapid_gun'
local HealthItem = require 'entities.health_item'

local RapidTurret = {}
function RapidTurret.new( left, top )
    local turret = {}
    turret.x = left
    turret.y = top
    turret.w = 20
    turret.h = 20
    turret.shots = 3
    turret.base_shots = 3
    turret.repeat_shot_reset_delay = 1
    turret.resetting = false
    turret.color = {255, 255, 0}
    turret.health = 1
    turret.die_callback = function()
        tiny.addEntity(ecs, RapidItem.new(turret.x + turret.w / 2, turret.y + turret.h / 2))
    end

    turret.vx = -60
    turret.vy = 0
    turret.is_enemy = true
    turret.is_rapid_turret = true
    turret.collision = {}
    turret.collision.filter =  function() return 'cross' end
    turret.collision.callback = function(col) end

    local gun = {}
    gun.ready = true
    gun.fire_delay = 1
    gun.create_bullet = function(turret)
        local bullet = {}
        bullet.x = turret.x - 10
        bullet.y = turret.y + turret.h / 2
        bullet.vx = -500
        bullet.vy = 0


        bullet.w = 8
        bullet.h = 8


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
            
            if other.is_player then
                other.health = other.health - bullet.damage
                tiny.removeEntity(ecs, bullet)
            elseif other.is_ground then
                tiny.removeEntity(ecs, bullet)
            end
        end

        bullet.color = {0, 255, 100 }
        tiny.addEntity(ecs, bullet)
    end

    turret.gun = gun
    turret.gun = RapidGun.new(RapidGun.new(RapidGun.new(RapidGun.new(RapidGun.new(turret.gun)))))


    return turret
end

return RapidTurret