local LoseGameRenderer = tiny.processingSystem()

LoseGameRenderer.draw = true
LoseGameRenderer.filter = tiny.requireAll('score')

function LoseGameRenderer:process(entity)

    love.graphics.setColor(209,196,73)
    love.graphics.setFont(entity.title_font)
    love.graphics.printf("You Lose!", 0, 0, love.window.getWidth(), 'center')
    love.graphics.setFont(entity.selection_font)
    love.graphics.printf("Score: " .. entity.score, 0, 300, love.window.getWidth(), 'center')
    love.graphics.printf("Gun: " .. entity.gun.create_name(),0,400,love.window.getWidth(),'center')
end
return LoseGameRenderer