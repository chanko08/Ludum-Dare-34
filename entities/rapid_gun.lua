local RapidGun = {}
local MAX_FIRE_RATE = 0.1

function RapidGun.new(gun)
    gun.fire_delay = math.max(gun.fire_delay / 4 * 3, MAX_FIRE_RATE)
    return gun
end

return RapidGun