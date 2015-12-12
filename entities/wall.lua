local Wall = {}

function Wall.new(left, top, width, height)
    local wall = {}

    wall.x = left
    wall.y = top
    wall.w = width
    wall.h = height
    wall.vx = 0
    wall.vy = 0
    wall.color = {0, 0, 255}
    
    wall.is_ground = true

    wall.collision = {}
    wall.static = true
    return wall
end

return Wall