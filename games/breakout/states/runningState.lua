local BaseState = require("states.baseState")
require "classes.paddle"
require "classes.ball"
require "classes.healthBar"
require "utils.displayText"
RunningState = BaseState:extend()

function RunningState:enter(params)
    self.isWaiting = true

    local selectedBallQuad = params.selectedBallQuad
    self.ball = Ball(selectedBallQuad)

    local selectedPaddleQuad = params.selectedPaddleQuad
    self.paddle = Paddle(selectedPaddleQuad)
    self.ball.y_velocity = 0
    self.ball.x_velocity = 0

    self.healthBar = HealthBar()
end

function RunningState:update(dt)
    self.paddle:update(dt)
    self.ball:update(dt)

    if self.isWaiting and love.keyboard.wasPressed('space') then
        self.isWaiting = false
        self.ball.y_velocity = -100
    elseif self.isWaiting and love.keyboard.isDown('left') then
        self.ball.x = self.ball.x - 150 * dt
        if self.ball.x <= 0 then
            self.ball.x = 0
        end
    elseif self.isWaiting and love.keyboard.isDown('right') then
        self.ball.x = self.ball.x + 150 * dt
        if self.ball.x >= VIRTUAL_WIDTH - self.ball.ballWidth then
            self.ball.x = VIRTUAL_WIDTH - self.ball.ballWidth
        end
    end

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
        self.healthBar.remainingHearts = self.healthBar.remainingHearts - 1

        if self.healthBar.remainingHearts == 0 then
            GStateMachine:change("gameOverState")
        elseif self.healthBar.remainingHearts > 0 then
            self.isWaiting = true
            self.ball:reset()
            self.paddle:reset()
        end
    end
end

function RunningState:render()
    if self.isWaiting then
        DisplayText("Press space to start", 'medium', (VIRTUAL_WIDTH / 2) - 100, (VIRTUAL_HEIGHT / 2) - 60)
    end
    self.healthBar:render()
    self.paddle:render()
    self.ball:render()
end
