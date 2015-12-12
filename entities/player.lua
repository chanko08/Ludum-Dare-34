local Player = {}

function Player.new(controls)
    local player = {}
    player.x = 100
    player.y = 100
    player.w = 64
    player.h = 64
    player.vx = 0
    player.vy = 0
    player.gravity = 500
    player.jump_force = -1000
    player.color = {255, 0, 0}
    player.health = 100
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
    end

    local level = {}
    level.create_turret   = true
    level.create_obstacle = true

    player.level = level

    local gun = {}
    

    gun.ready = true
    gun.fire_delay = 0.1
    gun.create_bullet = function(player)
        local bullet = {}
        bullet.x = player.x + player.w + 10
        bullet.y = player.y + player.h / 2
        bullet.vx = 1000
        bullet.vy = 0

        bullet.w = 8
        bullet.h = 8
        bullet.damage = 20
        bullet.is_bullet = true
        bullet.collision = {}
        bullet.collision.filter = function(item, other)
            local filter = {}
            filter.is_player = 'cross'
            filter.is_ground = 'touch'
            filter.is_enemy  = 'touch'

            for tag_name, resolution_type in pairs(filter) do
                if other[tag_name] then
                    return resolution_type
                end
            end

            --default to slide mechanics
            return 'cross'

        end

        bullet.collision.callback = function(col)
            local other = col.other
            local bullet = col.item
            if other.is_enemy then
                other.health = other.health - bullet.damage
            end

            if other.is_enemy or other.is_ground then
                tiny.removeEntity(ecs, col.item)
            end
        end

        bullet.color = {0, 255, 0 }
        local remove = _.curry(_.curry(tiny.removeEntity, ecs), bullet)
        Timer.after(love.window.getWidth() / bullet.vx * 3, remove)
        tiny.addEntity(ecs, bullet)
    end

    player.gun = gun
    return player
end

return Player