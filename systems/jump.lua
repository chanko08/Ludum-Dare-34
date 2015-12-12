local JumpSystem = tiny.processingSystem()

JumpSystem.filter = tiny.requireAll('vy','jump_force')

function JumpSystem:process(entity, dt)
    if love.keyboard.isDown(JUMP_KEY) then
        entity.vy = entity.vy + dt * entity.jump_force
    end
end

return JumpSystem