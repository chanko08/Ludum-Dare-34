local RapidGun = require 'entities.rapid_gun'
local RapidItem = {}

function RapidItem.new( x, y )
    local rapid = {}
    rapid.x = x
    rapid.vx = -200
    rapid.vy = 0 
    rapid.y = y
    rapid.w = 24
    rapid.h = 24
    rapid.is_item = true

    rapid.color = {255, 100, 0}

    rapid.collision = {}
    rapid.collision.filter = function(item, other)
        return 'cross'
    end

    rapid.collision.callback = function(col)
        local other = col.other
        local item  = col.item
        if other.is_player then
            other.gun = RapidGun.new(other.gun)
            tiny.removeEntity(ecs, item)
        end
    end

    return rapid
end

return RapidItem