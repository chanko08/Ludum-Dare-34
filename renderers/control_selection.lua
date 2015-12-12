local ControlSelectionRenderer = tiny.processingSystem()
ControlSelectionRenderer.draw = true
ControlSelectionRenderer.filter = tiny.requireAll("is_control_selection")

function ControlSelectionRenderer:process( entity )
    love.graphics.printf("ROBO BLAZE", 0, 0, love.window.getWidth(), 'center')

    if not entity.up_control then
        love.graphics.print("Select UP Button", 40, 40)
    else 
        love.graphics.print("UP Button: " .. entity.up_control_string, 40, 40)
    end

    if not entity.down_control then
        love.graphics.print("Select DOWN Button", 40, 80)
    else
        love.graphics.print("DOWN Button: " .. entity.down_control_string, 40, 80)
    end
end


return ControlSelectionRenderer