local BaseState = require("states.baseState")
StartState = BaseState:extend()

local highLighted = 1

function StartState:new()
end

function StartState:update(dt)
end

function StartState:render()
    love.graphics.setFont(Gfonts['large'])
    love.graphics.printf('BREAKOUT', 0, VIRTUAL_HEIGHT / 3,
        VIRTUAL_WIDTH, 'center')
end
