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

    if  entity.up_control then
        if entity.up_control_string == ev.control_string then
            entity.warning = "Cannot use only one button, pick another button"
            print("HEHEHEHEHEHEH")
            return
        end

        entity.down_control = cb
        entity.down_control_string = ev.control_string

        -- both selected, move to game screen
        local controls = {}
        controls.up_pressed = entity.up_control
        controls.down_pressed = entity.down_control
        entity.controls = controls
        Timer.after(2, function() switch_state(game_state, controls) end )
        return
    end

    entity.up_control = cb
    entity.up_control_string = ev.control_string
end

return ControlSelectionSystem