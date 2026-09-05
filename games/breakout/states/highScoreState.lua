local BaseState = require "states.BaseState"

HighScoreState = BaseState:extend()

function HighScoreState:enter(params)

end

function HighScoreState:update(dt)

end

function HighScoreState:render()
    local font = Gfonts.medium
    local message = "I a'int gonna work on it. I am done here"
    local exitMessage = "Click press ESCAPE to exit"
    local messageY = (VIRTUAL_HEIGHT / 2) - 30

    DisplayText(message, 'medium', (VIRTUAL_WIDTH - font:getWidth(message)) / 2, messageY)
    DisplayText(exitMessage, 'medium', (VIRTUAL_WIDTH - font:getWidth(exitMessage)) / 2, messageY + 30)
end
