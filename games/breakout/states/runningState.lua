local BaseState = require("states.baseState")
require "classes.paddle"
require "classes.ball"
require "utils.displayText"
RunningState = BaseState:extend()

function RunningState:enter(params)
    local selectedBallQuad = params.selectedBallQuad
    local defaultBallCord = params.ballStartingCords
    self.ball = Ball(selectedBallQuad)
    self.ball.x = defaultBallCord.defaultX
    self.ball.y = defaultBallCord.defaultY

    local selectedPaddleQuad = params.selectedPaddleQuad
    local defaultPaddleCord = params.paddleStartingCords
    self.paddle = Paddle(selectedPaddleQuad)
    self.paddle.x = defaultPaddleCord.defaultX
    self.paddle.y = defaultPaddleCord.defaultY
    self.ball.y_velocity = -100
    self.ball.x_velocity = 0
end

function RunningState:update(dt)
    self.paddle:update(dt)
    self.ball:update(dt)

    -- check ceiling collision of ball
    if self.ball.y <= 0 then
        self.ball.y = 0
        self.ball.y_velocity = math.abs(self.ball.y_velocity)
    end

    -- check side wall collision of ball
    if self.ball.x <= 0 then
        self.ball.x = 0
        self.ball.x_velocity = math.abs(self.ball.x_velocity)
    elseif self.ball.x + self.ball.ballWidth >= VIRTUAL_WIDTH then
        self.ball.x = VIRTUAL_WIDTH - self.ball.ballWidth
        self.ball.x_velocity = -math.abs(self.ball.x_velocity)
    end

    if self.ball.y >= VIRTUAL_HEIGHT then
        -- decrease a heart
        -- reset cords of paddle and ball
        -- reset velocity back to 0
        -- wait for space command to start again.
        -- on space pressed, check if game is waiting or not then proceed
        -- if all hearts are lost then show game over screen
    end
end

function RunningState:render()
    self.paddle:render()
    self.ball:render()
end
