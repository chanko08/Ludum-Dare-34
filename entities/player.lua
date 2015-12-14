local BasicGun = require 'entities.basic_gun'

local Player = {}

local PLAYER_PIC = love.graphics.newImage('assets/img/rob_sheet.png')
local PLAYER_GRID = anim8.newGrid(32, 40, PLAYER_PIC:getWidth(), PLAYER_PIC:getHeight())
local PLAYER_HOVER = anim8.newAnimation(PLAYER_GRID('1-2',1),0.1)
local PLAYER_FIRE  = anim8.newAnimation(PLAYER_GRID(3,1),0.1)



function Player.new(controls)
    local player = {}
    player.x = 100
    player.y = 100
    player.offset_x = -3
    player.offset_y = -3
    player.w = 26
    player.h = 26
    player.vx = 0
    player.vy = 0
    player.animation = PLAYER_HOVER
    player.hover_animation = PLAYER_HOVER
    player.fire_animation = PLAYER_FIRE
    player.image = PLAYER_PIC
    
    player.jump_force = -3000
    player.max_speed  = 300
    player.color = {255, 0, 0}
    player.health = 100
    player.max_health = 100
    player.score = 0
    player.die_callback = function ()
        switch_state(lose_state, player)
    end
    player.controls = controls
    player.is_player = true
    player.collision = {}
    player.collision.filter = function(item, other)
        local filter = {}
        filter.is_enemy  = 'cross'
        filter.is_item   = 'cross'
        filter.is_ground = 'touch'
        filter.is_bullet = 'cross'


        for tag_name, resolution_type in pairs(filter) do
            if other[tag_name] then
                return resolution_type
            end
        end

        --default to slide mechanics
        return 'touch'
    end

    player.collision.callback = function(col)
        if col.other.is_ground then
            col.item.vy = 0
        end

        if col.other.is_barrier then
            col.item.health = -1
        end
    end

    local level = {}
    level.create_turret   = true
    level.create_spinner  = true
    level.create_obstacle = true
    level.create_coins    = true
    level.create_rapid    = true
    level.time            = 0
    player.level = level
    player.gun = BasicGun.new(player)

    player.hud_overlay = love.graphics.newImage('assets/img/hud.png')
    player.hud_font    = love.graphics.newFont('assets/munro/MunroSmall.ttf', 32)
    player.score_font  = love.graphics.newFont('assets/prstartk.ttf', 16)


    return player
end

return Player