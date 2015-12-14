local ControlSelectionRenderer = tiny.processingSystem()
ControlSelectionRenderer.draw = true
ControlSelectionRenderer.filter = tiny.requireAll("is_control_selection")

function ControlSelectionRenderer:process( entity )
    love.graphics.setColor(132,189,151)
    love.graphics.setFont(entity.title_font)
    love.graphics.printf("ROBO BLAZE", 0, 0, love.window.getWidth(), 'center')

    love.graphics.setFont(entity.selection_font)


    love.graphics.print("Select UP Button:", 40, 400)
    if entity.up_control then
        love.graphics.printf(entity.up_control_string, 500, 400, 300, "right")
    end

    
    love.graphics.print("Select DOWN Button:", 40, 500)
    if entity.down_control then
        love.graphics.printf(entity.down_control_string, 500, 500, 300, "right")
    end
end


return ControlSelectionRenderer