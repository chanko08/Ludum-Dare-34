local COIN_PIC = love.graphics.newImage('assets/img/bitcoin_sheet.png')
local COIN_PIC_GRID = anim8.newGrid(14,14, COIN_PIC:getWidth(), COIN_PIC:getHeight())

local Coin = {}

function Coin.new( x, y, value )
    local coin = {}
    coin.x = x
    coin.y = y
    coin.image = COIN_PIC
    coin.animation = anim8.newAnimation(COIN_PIC_GRID('1-3',1), 0.1)

    coin.animation:gotoFrame(math.floor(math.rand(1,3)))
    
    coin.vx = -200
    coin.vy = 0

    coin.w = 10
    coin.h = 10
    coin.value = value

    coin.color = {255,255,255}

    coin.is_item = true

    coin.collision = {}
    coin.collision.filter = function(item, other)
        return 'cross'
    end

    coin.collision.callback = function(col)
        local other = col.other
        local item  = col.item
        if col.other.is_player then
            other.score = other.score + item.value
            tiny.removeEntity(ecs, item)
        end
    end

    return coin
end

return Coin