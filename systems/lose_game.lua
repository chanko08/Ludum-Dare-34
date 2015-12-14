local LoseGameSystem = tiny.processingSystem()

LoseGameSystem.keyboard = true
LoseGameSystem.filter = tiny.requireAll('score')

function LoseGameSystem:process(entity, ev)
    if ev.isDown then
        love.event.quit()
    end
end
return LoseGameSystem