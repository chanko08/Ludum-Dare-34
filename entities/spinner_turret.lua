local SpinnerTurret = {}
function SpinnerTurret.new( left, top )
    local turret = {}
    turret.x = left
    turret.y = top
    turret.w = 50
    turret.h = 50
    turret.color = {255, 255, 0}
    turret.health = 1

    turret.vx = -60
    turret.vy = 0

    turret.t = 0
    turret.spin_speed = math.rand(-5,5)

    turret.is_enemy = true
    turret.is_spinner_turret = true
    turret.collision = {}
    turret.collision.filter =  function() return 'cross' end
    turret.collision.callback = function(col) end

    local gun = {}
    gun.ready = true
    gun.fire_delay = .05
    gun.create_bullet = function(turret)
        local bullet = {}

        local dir_x = math.cos(turret.spin_speed*turret.t)
        local dir_y = math.sin(turret.spin_speed*turret.t)

        bullet.x = turret.x + turret.w / 2 + 30*dir_x
        bullet.y = turret.y + turret.h / 2 + 30*dir_y
        bullet.vx = 500 * dir_x
        bullet.vy = 500 * dir_y

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
            end
        end

        bullet.color = {0, 255, 255 }
        tiny.addEntity(ecs, bullet)
    end

    turret.gun = gun

    return turret
end

return SpinnerTurret