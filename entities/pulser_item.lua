local PulserGun = require 'entities.pulser_gun'
local PulserItem = {}

function PulserItem.new( x, y )
    local pulser = {}
    pulser.x = x
    pulser.vx = -200
    pulser.vy = 0 
    pulser.y = y
    pulser.w = 24
    pulser.h = 24
    pulser.is_item = true

    pulser.color = {255, 100, 0}

    pulser.collision = {}
    pulser.collision.filter = function(item, other)
        return 'cross'
    end

    pulser.collision.callback = function(col)
        local other = col.other
        local item  = col.item
        if other.is_player then
            other.gun = PulserGun.new(other.gun)
            tiny.removeEntity(ecs, item)
        end
    end

    return pulser
end

return PulserItem