local RapidGun = require 'entities.rapid_gun'
local RapidItem = {}

local RAPID_ITEM_PIC   = love.graphics.newImage('assets/img/powerup_sheet.png')
local RAPID_ITEM_GRID  = anim8.newGrid(16, 16, RAPID_ITEM_PIC:getWidth(), RAPID_ITEM_PIC:getHeight())

function RapidItem.new( x, y )
    local rapid = {}
    rapid.x = x
    rapid.vx = -200
    rapid.vy = 0 
    rapid.y = y
    rapid.w = 16
    rapid.h = 16
    rapid.is_item = true

    rapid.image = RAPID_ITEM_PIC
    rapid.animation = anim8.newAnimation(RAPID_ITEM_GRID('1-3',2), 0.2)

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