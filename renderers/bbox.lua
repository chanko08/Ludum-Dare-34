local BoundingBoxRenderer = tiny.processingSystem()

BoundingBoxRenderer.draw = true

BoundingBoxRenderer.filter = tiny.requireAll('x','y','w','h','color')

function BoundingBoxRenderer:process(entity, dt)
    -- print('bbox')
    local r,g,b = unpack(entity.color)
    love.graphics.setColor(r,g,b, 70)
    love.graphics.rectangle('fill', entity.x, entity.y, entity.w, entity.h)
    love.graphics.setColor(r,g,b)
    love.graphics.rectangle('line', entity.x, entity.y, entity.w, entity.h)
end

return BoundingBoxRenderer