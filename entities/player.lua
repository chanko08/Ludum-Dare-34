local BasicGun = require 'entities.basic_gun'

local Player = {}

function Player.new(controls)
    local player = {}
    player.x = 100
    player.y = 100
    player.w = 32
    player.h = 32
    player.vx = 0
    player.vy = 0
    
    player.jump_force = -3000
    player.max_speed  = 300
    player.color = {255, 0, 0}
    player.health = 100
    player.score = 0
    player.die_callback = function ()
        print('YOU DIED')
    end
    player.controls = controls
    player.is_player = true
    player.collision = {}
    player.collision.filter = function(item, other)
        local filter = {}
        filter.is_enemy  = 'cross'
        filter.is_item   = 'cross'
        filter.is_ground = 'touch'
        filter.is_bullet = 'cross'


        for tag_name, resolution_type in pairs(filter) do
            if other[tag_name] then
                return resolution_type
            end
        end

        --default to slide mechanics
        return 'touch'
    end

    player.collision.callback = function(col)
        if col.other.is_ground then
            col.item.vy = 0
        end

        if col.other.is_barrier then
            col.item.health = -1
        end
    end

    local level = {}
    level.create_turret   = true
    level.create_spinner  = true
    level.create_obstacle = true
    level.create_coins    = true
    player.level = level
    player.gun = BasicGun.new()

    return player
end

return Player