local HudSystem = tiny.processingSystem()

HudSystem.filter = tiny.requireAll('is_player')

local function float_to_binary_string(n)
    local s = ""
    repeat
        local digit = math.fmod(n,2)
        s = s .. digit
        n = math.floor((n - digit) / 2)
    until n <= 0

    return string.reverse(s)
end

function HudSystem:process(entity, dt)
    print(float_to_binary_string(entity.score))
end

return HudSystem