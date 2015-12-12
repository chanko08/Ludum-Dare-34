local TestTurretAI = tiny.processingSystem()

TestTurretAI.filter = tiny.requireAll('is_test_turret')

local function ready_gun(gun) 
    return function()
        gun.ready = true
    end
end

function TestTurretAI:process(entity, dt)
    if entity.gun.ready then
        entity.gun.ready = false
        -- create bullet
        entity.gun.create_bullet(entity)

        -- after timeout, 
        Timer.after(entity.gun.fire_delay, ready_gun(entity.gun))
    end
end

return TestTurretAI