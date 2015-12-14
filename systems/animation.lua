local AnimationSystem = tiny.processingSystem()

AnimationSystem.filter = tiny.requireAll('animation')

function AnimationSystem:process(entity, dt)
    entity.animation:update(dt)
end

return AnimationSystem