local Coin = {}
function Coin.new( x, y, value )
    local coin = {}
    coin.x = x
    coin.y = y

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