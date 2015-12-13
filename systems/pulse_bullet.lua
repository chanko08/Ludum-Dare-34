local PulseBulletSystem = tiny.processingSystem()

PulseBulletSystem.filter = tiny.requireAll('is_pulse_bullet')

local function pulseTween(entity)
    local max_height = entity.h + entity.gun.pulse_size
    local max_width  = entity.w + entity.gun.pulse_size
    local max_dim    = {w = max_width, h = max_height}

    local min_height = entity.h   
    local min_width  = entity.w
    local min_dim    = {w = min_width, h = min_height}


    Timer.tween(entity.pulse_rate / 2, entity, max_dim, "in-out-sine", function()
        Timer.tween(entity.pulse_rate / 2, entity, min_dim, "in-out-sine", function()
            entity.pulse_tween_done = true
        end)
    end)
end

function PulseBulletSystem:process(entity, dt)
    if entity.pulse_tween_done then
        entity.pulse_tween_done = false
        print('restart!')
        pulseTween(entity)
    end

    world:update(entity, entity.x, entity.y, entity.w, entity.h)
end

return PulseBulletSystem