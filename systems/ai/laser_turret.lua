local LaserTurretAI = tiny.processingSystem()

LaserTurretAI.filter = tiny.requireAll('is_laser_turret')

local function ready_gun(gun) 
    return function()
        gun.ready = true
    end
end

local function reset_shots(entity)
    return function()
        -- entity.animation = entity.fire_animation
        -- entity.animation:gotoFrame(4)
        entity.shots = entity.base_shots
        entity.resetting = false

    end
end

function LaserTurretAI:process(entity, dt)
    
    if entity.gun.ready and entity.x < love.window.getWidth() and entity.shots > 0 then
        entity.gun.ready = false
        entity.shots = entity.shots - 1
        
        entity.gun.create_bullet(entity)

        Timer.after(entity.gun.fire_delay, ready_gun(entity.gun))
    end

    if entity.shots <= 0 and not entity.resetting then
        entity.resetting = true
        -- entity.animation = entity.resting_animation
        Timer.after(entity.repeat_shot_reset_delay, reset_shots(entity))
    end
end

return LaserTurretAI