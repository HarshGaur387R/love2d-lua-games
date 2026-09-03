local BaseState = require("states.baseState")
require "classes.paddle"
require "classes.ball"
require "utils.displayText"
PlayState = BaseState:extend()

function PlayState:enter(params)
    self.params = params
    local selectedPaddleQuad = params.selectedPaddleQuad
    local selectedBallQuad = params.selectedBallQuad
    self.paddle = Paddle(selectedPaddleQuad)
    self.ball = Ball(selectedBallQuad)
end

function PlayState:update(dt)
    self.paddle:update(dt)
    self.ball:update(dt)

    if love.keyboard.wasPressed('space') then
        -- add paddle's starting cord in the params
        local ballStartingCords = { defaultX = self.ball.x, defaultY = self.ball.y }
        local paddleStartingCords = { defaultX = self.paddle.x, defaultY = self.paddle.y }
        self.params["ballStartingCords"] = ballStartingCords
        self.params["paddleStartingCords"] = paddleStartingCords
        GStateMachine:change("runningState", self.params)
    end
end

function PlayState:render()
    DisplayText("Press space to start the game.", 'medium', (VIRTUAL_WIDTH / 2) - 135, (VIRTUAL_HEIGHT / 2) - 60)
    self.paddle:render()
    self.ball:render()
end
