local HealthItem = {}
local MAX_HEALTH = 100
local HEALTH_POWER_UP = 10

local HEALTH_ITEM_PIC   = love.graphics.newImage('assets/img/health_sheet.png')
local HEALTH_ITEM_GRID  = anim8.newGrid(24, 24, HEALTH_ITEM_PIC:getWidth(), HEALTH_ITEM_PIC:getHeight())

function HealthItem.new( x, y )
    local health = {}
    health.x = x
    health.vx = -200
    health.vy = 0 
    health.y = y
    health.w = 24
    health.h = 24
    health.is_item = true

    health.image = HEALTH_ITEM_PIC
    health.animation = anim8.newAnimation(HEALTH_ITEM_GRID('1-4',1), 0.2)

    health.color = {255, 100, 0}

    health.collision = {}
    health.collision.filter = function(item, other)
        return 'cross'
    end

    health.collision.callback = function(col)
        local other = col.other
        local item  = col.item
        if other.is_player then
            other.health = math.min(MAX_HEALTH, other.health + HEALTH_POWER_UP)
            tiny.removeEntity(ecs, item)
        end
    end

    return health
end

return HealthItem