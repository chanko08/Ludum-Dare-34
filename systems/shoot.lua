local ShootSystem = tiny.processingSystem()

ShootSystem.filter = tiny.requireAll('is_player')

local function ready_gun(gun) 
    return function()
        gun.ready = true
    end
end

function ShootSystem:process(entity, dt)
    if entity.controls.shoot_pressed() and entity.gun.ready then
        entity.gun.ready = false
        -- create bullet
        entity.gun.create_bullet(entity)

        -- after timeout, 
        Timer.after(entity.gun.fire_delay, ready_gun(entity.gun))
    end 
end

return ShootSystem
