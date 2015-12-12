local CleanSystem = tiny.processingSystem()

CleanSystem.filter = tiny.requireAll('x','y','w', 'h')

function CleanSystem:process(entity, dt)
    if entity.x + entity.w + 100 < 0 then
        tiny.removeEntity(ecs, entity)
    end
end

return CleanSystem