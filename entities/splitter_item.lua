local SplitterGun = require 'entities.splitter_gun'
local SplitterItem = {}

local SPLITTER_ITEM_PIC   = love.graphics.newImage('assets/img/powerup_sheet.png')
local SPLITTER_ITEM_GRID  = anim8.newGrid(16, 16, SPLITTER_ITEM_PIC:getWidth(), SPLITTER_ITEM_PIC:getHeight())


function SplitterItem.new( x, y )
    local splitter = {}
    splitter.x = x
    splitter.vx = -200
    splitter.vy = 0 
    splitter.y = y
    splitter.w = 16
    splitter.h = 16
    splitter.is_item = true

    splitter.image = SPLITTER_ITEM_PIC
    splitter.animation = anim8.newAnimation(SPLITTER_ITEM_GRID('1-3',3), 0.2)

    splitter.color = {255, 100, 0}

    splitter.collision = {}
    splitter.collision.filter = function(item, other)
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