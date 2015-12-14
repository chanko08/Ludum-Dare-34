local PulserGun = require 'entities.pulser_gun'
local PulserItem = {}

local PULSER_ITEM_PIC   = love.graphics.newImage('assets/img/powerup_sheet.png')
local PULSER_ITEM_GRID  = anim8.newGrid(16, 16, PULSER_ITEM_PIC:getWidth(), PULSER_ITEM_PIC:getHeight())


function PulserItem.new( x, y )
    local pulser = {}
    pulser.x = x
    pulser.vx = -200
    pulser.vy = 0 
    pulser.y = y
    pulser.w = 16
    pulser.h = 16
    pulser.is_item = true

    pulser.image = PULSER_ITEM_PIC
    pulser.animation = anim8.newAnimation(PULSER_ITEM_GRID('1-3',1), 0.2)

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