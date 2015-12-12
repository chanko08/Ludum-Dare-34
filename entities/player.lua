local Player = {}

function Player.new()
    local player = {}
    player.x = 100
    player.y = 100
    player.w = 64
    player.h = 64
    player.vx = 0
    player.vy = 0
    player.gravity = 500
    player.jump_force = -1000
    player.color = {255, 0, 0}

    local gun = {}
    

    gun.ready = true
    gun.fire_delay = 0.1
    gun.create_bullet = function(player)
        local bullet = {}
        bullet.x = player.x + player.w + 10
        bullet.y = player.y + player.h / 2
        bullet.vx = 1000
        bullet.vy = 0

        bullet.w = 8
        bullet.h = 8

        bullet.color = {0, 255, 0 }

        tiny.addEntity(ecs, bullet)
    end

    player.gun = gun
    return player
end

return Player