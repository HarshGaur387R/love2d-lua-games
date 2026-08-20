local BaseState = require("states.baseState")
StartState = BaseState:extend()

local highLighted = 1
local selectedY = 38       -- current Y position of rectangle
local targetY = 38         -- target Y position
local animationSpeed = 300 -- pixels per second

function StartState:update(dt)
    if love.keyboard.wasPressed("up") or love.keyboard.wasPressed("down") then
        highLighted = highLighted == 1 and 2 or 1
        -- Set target Y based on which option is highlighted
        targetY = highLighted == 1 and 38 or 63
        GSounds["paddle-hit"]:play()
    end

    -- Smoothly animate toward the target Y
    if selectedY ~= targetY then
        local diff = targetY - selectedY
        local distance = math.abs(diff)
        local moveAmount = animationSpeed * dt

        if distance <= moveAmount then
            selectedY = targetY
        else
            selectedY = selectedY + (diff > 0 and moveAmount or -moveAmount)
        end
    end

    if love.keyboard.wasPressed("enter") or love.keyboard.wasPressed("return") then
        if highLighted == 1 then
            GStateMachine:change("selectPedalState")
            GSounds['confirm']:play()
        end
    end
end

function StartState:render()
    love.graphics.setFont(Gfonts['large'])
    love.graphics.printf('BREAKOUT', 0, VIRTUAL_HEIGHT / 3, VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(Gfonts['medium'])

    -- Draw the animated rectangle at the current position
    love.graphics.rectangle("fill", VIRTUAL_WIDTH / 2 - 60, VIRTUAL_HEIGHT / 3 + selectedY, 120, 20)

    if highLighted == 1 then
        love.graphics.setColor(0, 0, 0, 1)
        love.graphics.printf('Play Now', 0, VIRTUAL_HEIGHT / 3 + 40, VIRTUAL_WIDTH, 'center')
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.printf('HighScores', 0, VIRTUAL_HEIGHT / 3 + 65, VIRTUAL_WIDTH, 'center')
    else
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.printf('Play Now', 0, VIRTUAL_HEIGHT / 3 + 40, VIRTUAL_WIDTH, 'center')
        love.graphics.setColor(0, 0, 0, 1)
        love.graphics.printf('HighScores', 0, VIRTUAL_HEIGHT / 3 + 65, VIRTUAL_WIDTH, 'center')
    end

    love.graphics.setColor(1, 1, 1, 1) -- Reset color
end
