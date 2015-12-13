local SplitterGun = require 'entities.splitter_gun'
local SplitterItem = {}

function SplitterItem.new( x, y )
    local splitter = {}
    splitter.x = x
    splitter.vx = -200
    splitter.vy = 0 
    splitter.y = y
    splitter.w = 24
    splitter.h = 24

    splitter.color = {255, 100, 0}

    splitter.collision = {}
    splitter.collision.filter = function(item, other)
        if other.is_player then
            return 'touch'
        end

        return 'cross'
    end

    splitter.collision.callback = function(col)
        local other = col.other
        local item  = col.item
        if other.is_player then
            other.gun = SplitterGun.new(other.gun)
            tiny.removeEntity(ecs, item)
        end
    end

    return splitter
end

return SplitterItem