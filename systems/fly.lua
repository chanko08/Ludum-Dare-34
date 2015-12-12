local FlySystem = tiny.processingSystem()

FlySystem.filter = tiny.requireAll('is_player')

function FlySystem:process(entity, dt)
    local ctrl = entity.controls
    if ctrl.up_pressed() and ctrl.down_pressed() then
        entity.vy = 0
    elseif ctrl.up_pressed() then
        entity.vy = -entity.max_speed
    elseif ctrl.down_pressed() then
        entity.vy = entity.max_speed
    else
        entity.vy = 0
    end

end

return FlySystem