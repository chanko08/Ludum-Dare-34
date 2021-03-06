local SplitterItem = require 'entities.splitter_item'
local HealthItem = require 'entities.health_item'

local SPINNER_PIC   = love.graphics.newImage('assets/img/spinner_sheet.png')
local SPINNER_GRID  = anim8.newGrid(50, 50, SPINNER_PIC:getWidth(), SPINNER_PIC:getHeight())

local SPINNER_BULLET_PIC = love.graphics.newImage('assets/img/bullet1b_sheet.png')
local SPINNER_BULLET_GRID = anim8.newGrid(8,8, SPINNER_BULLET_PIC:getWidth(), SPINNER_BULLET_PIC:getHeight())

local SpinnerTurret = {}
function SpinnerTurret.new( left, top )
    local turret = {}
    turret.x = left
    turret.y = top
    turret.w = 50
    turret.h = 50
    turret.image = SPINNER_PIC
    turret.fire_animation = anim8.newAnimation(SPINNER_GRID('1-2',1),0.025)
    turret.animation = turret.fire_animation
    turret.color = {255, 255, 0}
    turret.health = 1
    turret.die_callback = function()
        if math.random() <= 0.8 then
            if math.random() <= 0.8 then
                tiny.addEntity(ecs, SplitterItem.new(turret.x + turret.w / 2, turret.y + turret.h / 2))
            else
                tiny.addEntity(ecs, HealthItem.new(turret.x + turret.w / 2, turret.y + turret.h / 2))
            end         
        end
    end

    turret.vx = -60
    turret.vy = 0

    turret.t = 0
    turret.spin_speed = math.rand(-5,5)

    turret.is_enemy = true
    turret.is_spinner_turret = true
    turret.collision = {}
    turret.collision.filter =  function() return 'cross' end
    turret.collision.callback = function(col) end

    local gun = {}
    gun.ready = true
    gun.fire_delay = .05
    gun.create_bullet = function(turret)
        local bullet = {}

        local dir_x = math.cos(turret.spin_speed*turret.t)
        local dir_y = math.sin(turret.spin_speed*turret.t)

        bullet.x = turret.x + turret.w / 2 + 30*dir_x
        bullet.y = turret.y + turret.h / 2 + 30*dir_y
        bullet.vx = 500 * dir_x
        bullet.vy = 500 * dir_y

        bullet.w = 8
        bullet.h = 8

        bullet.move_animation = anim8.newAnimation(SPINNER_BULLET_GRID('1-2',1), 0.3)
        bullet.explode_animation = anim8.newAnimation(SPINNER_BULLET_GRID(3,1), 0.2)
        bullet.animation = bullet.move_animation
        bullet.image = SPINNER_BULLET_PIC

        bullet.damage = 10
        bullet.is_bullet = true

        bullet.collision = {}
        bullet.collision.filter = function(item, other)
            local filter = {}
            filter.is_player = 'touch'
            filter.is_ground = 'cross'
            filter.is_item   = 'cross'
            filter.is_enemy  = 'cross'
            filter.is_bullet = 'cross'

            for tag_name, resolution_type in pairs(filter) do
                if other[tag_name] then
                    return resolution_type
                end
            end

            --default to slide mechanics
            return 'slide'
        end

        bullet.collision.callback = function(col)
            local other = col.other
            local bullet = col.item
            
            if other.is_player and not col.item.is_exploded then
                other.health = other.health - bullet.damage
                col.item.is_exploded = true
                col.item.animation = col.item.explode_animation
                Timer.after(0.05, function() tiny.removeEntity(ecs, col.item) end)
            elseif other.is_ground and not col.item.is_exploded then
                col.item.is_exploded = true
                col.item.animation = col.item.explode_animation 
                Timer.after(0.05, function() tiny.removeEntity(ecs, col.item) end)
            end
        end

        bullet.color = {0, 255, 255 }
        tiny.addEntity(ecs, bullet)
    end

    turret.gun = gun

    return turret
end

return SpinnerTurret