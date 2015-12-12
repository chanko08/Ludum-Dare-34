local ControlSelectionSystem = tiny.processingSystem()
ControlSelectionSystem.keyboard = true
ControlSelectionSystem.joystick = true
ControlSelectionSystem.filter = tiny.requireAll("is_control_selection")


function keypressed_func(key)
    return function()
        return love.keyboard.isDown(key)
    end
end

function keyToString(key)
    if key == ' ' then
        return "SPACE"
    end
    return key
end

function ControlSelectionSystem:process(entity, ev)
    if entity.controls then
        return
    end
    
    if entity.control_type == 'joystick' and ev.type == 'keyboard' or
        entity.control_type == 'keyboard' and ev.type == 'joystick' then
        entity.warning = "Buttons must both be on the same controller/keyboard"
        return
    end

    local cb
    if ev.key and ev.isDown then
        cb = keypressed_func(ev.key)
        entity.control_type = 'keyboard'
        ev.control_string = keyToString(ev.key)
    else
        return
    end

    if  entity.jump_control then
        entity.shoot_control = cb
        entity.shoot_control_string = ev.control_string

        -- both selected, move to game screen
        local controls = {}
        controls.jump_pressed = entity.jump_control
        controls.shoot_pressed = entity.shoot_control
        entity.controls = controls
        Timer.after(2, function() switch_state(game_state, controls) end )
        return
    end

    entity.jump_control = cb
    entity.jump_control_string = ev.control_string
end

return ControlSelectionSystem