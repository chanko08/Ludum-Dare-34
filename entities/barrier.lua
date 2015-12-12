local Barrier = {}

function Barrier.new(left, top, width, height)
    local barrier = {}

    barrier.x = left
    barrier.y = top
    barrier.w = width
    barrier.h = height
    barrier.vx = -200
    barrier.vy = 0
    barrier.color = {0, 0, 255}
    
    barrier.is_ground = true
    barrier.static = false

    barrier.collision = {}
    barrier.collision.filter = function(item, other)
        local filter = {}
        filter.is_enemy  = 'cross'
        filter.is_item   = 'cross'
        filter.is_ground = 'cross'
        filter.is_bullet = 'cross'
        filter.is_player = 'cross'


        for tag_name, resolution_type in pairs(filter) do
            if other[tag_name] then
                return resolution_type
            end
        end

        --default to slide mechanics
        return 'cross'
    end

    barrier.collision.callback = function(col)  end
    return barrier
end

return Barrier