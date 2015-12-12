local ControlSelectionRenderer = tiny.processingSystem()
ControlSelectionRenderer.draw = true
ControlSelectionRenderer.filter = tiny.requireAll("is_control_selection")

function ControlSelectionRenderer:process( entity )
    love.graphics.printf("ROBO BLAZE", 0, 0, love.window.getWidth(), 'center')

    if not entity.jump_control then
        love.graphics.print("Select JUMP Button", 40, 40)
    else 
        love.graphics.print("JUMP Button: " .. entity.jump_control_string, 40, 40)
    end

    if not entity.shoot_control then
        love.graphics.print("Select SHOOT Button", 40, 80)
    else
        love.graphics.print("SHOOT Button: " .. entity.shoot_control_string, 40, 80)
    end
end


return ControlSelectionRenderer