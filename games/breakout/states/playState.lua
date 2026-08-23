local BaseState = require("states.baseState")
require "classes.paddle"

PlayState = BaseState:extend()

function PlayState:enter(selectedPaddleQuad)
    self.paddle = Paddle(selectedPaddleQuad)
end

function PlayState:update(dt)
    self.paddle:update(dt)
end

function PlayState:render()
    self.paddle:render()
end
