local PhysicsSystem = tiny.processingSystem()

PhysicsSystem.filter = tiny.requireAll('x','y','vx','vy', 'collision')

function PhysicsSystem:onAdd(entity)
    
    world:add(
        entity,
        entity.x,
        entity.y,
        entity.w,
        entity.h
    )
end

function PhysicsSystem:onRemove(entity)
    world:remove(entity)
end

function PhysicsSystem:process(entity, dt)
    if entity.static then       
        return
    end

    if entity.gravity then
        entity.vy = entity.vy + entity.gravity * dt
    end

    local dx = entity.vx * dt
    local dy = entity.vy * dt

    local cols, n_cols
    entity.x, entity.y, cols, n_cols = world:move(entity, entity.x + dx, entity.y + dy, entity.collision.filter)

    for i=1, n_cols do
        local col = cols[i]
        entity.collision.callback(col)
        print(("col.other = %s, col.type = %s, col.normal = %d,%d"):format(col.other, col.type, col.normal.x, col.normal.y))
    end
end

return PhysicsSystem