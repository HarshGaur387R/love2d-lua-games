local BaseState = require("states.baseState")
require "utils.generateQuadsPeddles"
SelectPedalState = BaseState:extend()

function SelectPedalState:new()
    self.Peddles = GenerateQuadsPaddles(GTextures['main'])
    self.leftArrow = love.graphics.newQuad(0, 0, 24, 24, GTextures['arrows']:getWidth(), GTextures['arrows']:getHeight())
    self.rightArrow = love.graphics.newQuad(24, 0, 24, 24, GTextures['arrows']:getWidth(),
        GTextures['arrows']:getHeight())
    self.peddleIndex = 2
end

function SelectPedalState:update(dt)
    if love.keyboard.wasPressed('left') then
        if self.peddleIndex - 4 > 0 then
            self.peddleIndex = self.peddleIndex - 4
        end
    elseif love.keyboard.wasPressed('right') then
        if self.peddleIndex + 4 < 16 then
            self.peddleIndex = self.peddleIndex + 4
        end
    elseif love.keyboard.wasPressed('return') or love.keyboard.wasPressed('enter') then
        GStateMachine:change('playState', self.Peddles[self.peddleIndex])
    end
end

function SelectPedalState:render()
    love.graphics.setFont(Gfonts['medium'])
    love.graphics.print("Press ENTER to select peddle", VIRTUAL_WIDTH - 340, 30)
    love.graphics.draw(GTextures['arrows'], self.leftArrow, 30, VIRTUAL_HEIGHT / 2)
    love.graphics.draw(GTextures['arrows'], self.rightArrow, VIRTUAL_WIDTH - 54, VIRTUAL_HEIGHT / 2)

    local _, _, paddleWidth = self.Peddles[self.peddleIndex]:getViewport()
    love.graphics.draw(GTextures['main'], self.Peddles[self.peddleIndex],
        VIRTUAL_WIDTH / 2 - paddleWidth / 2, VIRTUAL_HEIGHT / 2 + 5)

    love.graphics.setFont(Gfonts['small'])
end
