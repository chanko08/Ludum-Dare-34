local ShootSystem = tiny.processingSystem()

ShootSystem.filter = tiny.requireAll('is_player')

local function ready_gun(gun) 
    return function()
        gun.ready = true
    end
end

local function reset_animation(entity)
    return function()
        entity.animation = entity.hover_animation
    end
end

function ShootSystem:process(entity, dt)
    if entity.gun.ready then
        entity.gun.ready = false
        -- create bullet
        entity.gun.create_bullet(entity.x + entity.w, entity.y + entity.h / 2 - entity.gun.base_bullet_height/2, 1, 0)
        entity.animation = entity.fire_animation 
        -- after timeout, 
        Timer.after(entity.gun.fire_delay, ready_gun(entity.gun))
        Timer.after(0.1, reset_animation(entity))
    end 
end

return ShootSystem
