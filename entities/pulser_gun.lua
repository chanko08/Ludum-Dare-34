local PulserGun = {}

local MAX_PULSE_SIZE = 50
local PULSE_RATE = 0.5 -- time it takes to go from small to big size to small again

function create_pulse_bullet( gun, bullet_constructor )
    return function(start_x, start_y, start_dx, start_dy)
        print(inspect(gun))
        local b = bullet_constructor(start_x, start_y, start_dx, start_dy)
        b.is_pulse_bullet = true
        b.gun = gun
        b.pulse_tween_done = true
        b.pulse_rate = PULSE_RATE
        b.x_offset = 0
        b.y_offset = 0
    end 
end

function PulserGun.new(gun)
    if not gun.pulse_size then
        gun.pulse_size = 5

        local create_bullet = gun.create_bullet
        gun.create_bullet = create_pulse_bullet(gun, create_bullet) 
    else
        gun.pulse_size = math.min(gun.pulse_size + 10, MAX_PULSE_SIZE)
    end

    return gun
end

return PulserGun