local HudRenderer = tiny.processingSystem()

HudRenderer.draw = true
HudRenderer.filter = tiny.requireAll('is_player')

local function float_to_binary_string(n)
    local s = ""
    repeat
        local digit = math.fmod(n,2)
        s = s .. digit
        n = math.floor((n - digit) / 2)
    until n <= 0

    return string.reverse(s)
end

local function firstToUpper(str)
    return (str:gsub("^%l", string.upper))
end

function HudRenderer:process(entity, dt)
    love.graphics.reset()
    love.graphics.draw(entity.hud_overlay, 0, 0)

    love.graphics.setFont(entity.hud_font)
    love.graphics.print(firstToUpper(entity.gun.create_name()), 21, 661)
    love.graphics.setFont(entity.score_font)
    love.graphics.printf(float_to_binary_string(entity.score), 858, 41, 400, 'right')

    love.graphics.setColor(240, 78, 34, 70)
    love.graphics.rectangle(
        'fill',
        25,
        45,
        math.floor((334 - 25)*entity.health /entity.max_health),
        20
    )
end

return HudRenderer