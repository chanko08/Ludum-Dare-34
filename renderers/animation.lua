local AnimationRenderer = tiny.processingSystem()

AnimationRenderer.draw = true

AnimationRenderer.filter = tiny.requireAll('x','y','animation','image')

function AnimationRenderer:process(entity, dt)
    love.graphics.reset()
    local offset_x = 0
    if entity.offset_x then
        offset_x = entity.offset_x
    end
    
    local offset_y = 0
    if entity.offset_y then
        offset_y = entity.offset_y
    end
    
    local scale = 1
    if entity.scale then
        scale = entity.scale
    end

    entity.animation:draw(entity.image, entity.x + offset_x, entity.y + offset_y,0, scale, scale)
end

return AnimationRenderer