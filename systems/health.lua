local HealthSystem = tiny.processingSystem()

HealthSystem.filter = tiny.requireAll('health')

function HealthSystem:process(entity, dt)
    if entity.health <= 0 then
        if entity.die_callback then
            entity.die_callback()
        end
        tiny.removeEntity(ecs, entity) 
         if entity.is_player then
            love.event.quit()
        end
    end


end

return HealthSystem