local PulserGun = {}

local MAX_PULSE_SIZE = 10
local PULSE_SIZE_RATE = 1
local PULSE_RATE = 0.5 -- time it takes to go from small to big size to small again
local PULSE_ADJECTIVES = {
    "pulsing",
    "fluttering",
    "beating",
    "throbbing",
    "vibrating",
    "oscillating",
    "stroking",
    "palpitating",
    "fluctuating",
    "roaring"
} 

local function create_pulse_bullet( gun, bullet_constructor )
    return function(start_x, start_y, start_dx, start_dy)
        
        local bs = bullet_constructor(start_x, start_y, start_dx, start_dy)
        for i,b in ipairs(bs) do
            b.is_pulse_bullet = true
            b.gun = gun
            b.pulse_tween_done = true
            b.pulse_rate = PULSE_RATE
            b.x_offset = 0
            b.y_offset = 0
            b.scale = 1
        end
        
        return bs
    end 
end

local function create_pulse_name( gun, name_constructor )
    return function()
        --print('here')
        return PULSE_ADJECTIVES[math.floor(gun.pulse_size / PULSE_SIZE_RATE)] .. " " .. name_constructor()
    end
end

function PulserGun.new(gun)
    if not gun.pulse_size then
        gun.pulse_size = 2

        local create_bullet = gun.create_bullet
        gun.create_bullet = create_pulse_bullet(gun, create_bullet) 


        local name_gun = gun.create_name
        gun.create_name = create_pulse_name(gun, name_gun)
        --print('named gun', gun.create_name())
    else
        gun.pulse_size = math.min(gun.pulse_size + PULSE_SIZE_RATE, MAX_PULSE_SIZE)
    end

    return gun
end

return PulserGun