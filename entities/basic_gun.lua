local BasicGun = {}
function BasicGun.new()
    local gun = {}
    

    gun.ready = true
    gun.fire_delay = 0.5
    gun.base_bullet_width = 8
    gun.base_bullet_height = 8
    gun.create_bullet = function(start_x, start_y, start_dx, start_dy)
        local bullet = {}
        bullet.x = start_x
        bullet.y = start_y
        bullet.vx = 1000 * start_dx
        bullet.vy = 0 * start_dy

        bullet.w = gun.base_bullet_width
        bullet.h = gun.base_bullet_height
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

    return gun
end

return BasicGun