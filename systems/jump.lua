local JumpSystem = tiny.processingSystem()

JumpSystem.filter = tiny.requireAll('vy','jump_force')

function JumpSystem:process(entity, dt)
    if entity.controls.jump_pressed() then
        entity.vy = entity.vy + dt * entity.jump_force
    end
end

return JumpSystem