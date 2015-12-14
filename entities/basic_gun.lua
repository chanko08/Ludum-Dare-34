
local BULLET_PIC   = love.graphics.newImage('assets/img/bullet1_sheet.png')
local BULLET_GRID  = anim8.newGrid(8, 8, BULLET_PIC:getWidth(), BULLET_PIC:getHeight())



local BasicGun = {}
function BasicGun.new(player)
    local gun = {}
    
    gun.player = player
    gun.ready = true
    gun.fire_delay = 0.5
    gun.base_bullet_width = 8
    gun.base_bullet_height = 8
    
    gun.create_name = function()
        return "robo-cannon"
    end
    gun.create_bullet = function(start_x, start_y, start_dx, start_dy)
        local bullet = {}
        bullet.move_animation = anim8.newAnimation(BULLET_GRID('1-2',1), 0.3)
        bullet.explode_animation = anim8.newAnimation(BULLET_GRID(3,1), 0.2)
        bullet.animation = bullet.move_animation
        bullet.image = BULLET_PIC
        bullet.x = start_x
        bullet.y = start_y
        local bv = 1000*Vector(start_dx, start_dy)
        
        bullet.vx = bv.x
        bullet.vy = bv.y

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

            if other.is_enemy then
                local value = other.score_value
                if not value then
                    value = 7
                end
                gun.player.score = gun.player.score + value
            end

            if other.is_enemy or other.is_ground then
                col.item.animation = col.item.explode_animation
                Timer.after(0.2, function() tiny.removeEntity(ecs, col.item) end)
            end
        end

        bullet.color = {0, 255, 0 }
        local remove = _.curry(_.curry(tiny.removeEntity, ecs), bullet)
        Timer.after(love.window.getWidth() / bullet.vx * 3, remove)
        tiny.addEntity(ecs, bullet)
        return {bullet}
    end

    return gun
end

return BasicGun