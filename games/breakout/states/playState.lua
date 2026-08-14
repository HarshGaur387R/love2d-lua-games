local BaseState = require("states.baseState")
PlayState = BaseState:extend()

function PlayState:update(dt) end

function PlayState:render()
    love.graphics.print("Hello from PlayState", 10, 10)
end