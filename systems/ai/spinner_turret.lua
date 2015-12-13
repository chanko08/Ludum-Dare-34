local SpinnerTurretAI = tiny.processingSystem()

SpinnerTurretAI.filter = tiny.requireAll('is_spinner_turret')

local function ready_gun(gun) 
    return function()
        gun.ready = true
    end
end

function SpinnerTurretAI:process(entity, dt)
    entity.t = entity.t + dt

    if entity.gun.ready and entity.x < love.window.getWidth() then
        entity.gun.ready = false
        -- create bullet
        entity.gun.create_bullet(entity)

        -- after timeout, 
        Timer.after(entity.gun.fire_delay, ready_gun(entity.gun))
    end
end

return SpinnerTurretAI