local RapidGun = {}
local MAX_FIRE_RATE = 0.01
local START_FIRE_DELAY = 0.5

local RAPID_ADJECTIVES = {
    "rapid",
    "accelerated",
    "screaming",
    "brisk",
    "winged",
    "hyper",
    "frisky",
    "perky",
    "prompt",
    "spry",
    "ejaculating",
    "breakneck",
    "progressive",
    "time traveling",
    "exertive",
    "energy non-conserving",
    "mad rhyme flowing"
}

local function solve_rapidity_level(delay)
    if delay <= MAX_FIRE_RATE then
        return 0
    end

    return 1 + solve_rapidity_level(delay / 7 * 5)
end

local function create_rapid_name( gun, name_constructor )
    return function()
        return RAPID_ADJECTIVES[#RAPID_ADJECTIVES - solve_rapidity_level(gun.fire_delay)] .. " " .. name_constructor()
    end
end

function RapidGun.new(gun)
    if gun.fire_delay >= 0.5 then
        gun.create_name = create_rapid_name(gun, gun.create_name)
    end
    gun.fire_delay = math.max(gun.fire_delay / 4 * 3, MAX_FIRE_RATE)
    return gun
end

return RapidGun