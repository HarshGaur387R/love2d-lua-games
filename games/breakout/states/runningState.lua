local BaseState = require("states.baseState")
require "classes.paddle"
require "classes.ball"
require "classes.healthBar"
require "classes.levelMaker"
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
    self.bricks = LevelMaker:CreateMap(1)
end

-- ⚠️ WARNING: "AI generated code" |
-- Checking paddle to ball collision and simulating ball physics after hit
function RunningState:checkPaddleCollision()
    local _, _, ballWidth, ballHeight = self.ball.ballQuad:getViewport()
    local _, _, paddleWidth, paddleHeight = self.paddle.paddleQuad:getViewport()

    local isOverlapping = self.ball.x < self.paddle.x + paddleWidth
        and self.ball.x + ballWidth > self.paddle.x
        and self.ball.y < self.paddle.y + paddleHeight
        and self.ball.y + ballHeight > self.paddle.y

    if isOverlapping and self.ball.y_velocity > 0 then
        self.ball.y = self.paddle.y - ballHeight
        self.ball.y_velocity = -math.abs(self.ball.y_velocity)

        local paddleCenter = self.paddle.x + paddleWidth / 2
        local ballCenter = self.ball.x + ballWidth / 2
        local hitPosition = (ballCenter - paddleCenter) / (paddleWidth / 2)
        self.ball.x_velocity = hitPosition * 150
    end
end

function RunningState:checkBrickCollision()
    local _, _, ballWidth, ballHeight = self.ball.ballQuad:getViewport()

    for _, brick in ipairs(self.bricks) do
        if brick.inPlay then
            local isOverlapping = self.ball.x < brick.x + brick.width
                and self.ball.x + ballWidth > brick.x
                and self.ball.y < brick.y + brick.height
                and self.ball.y + ballHeight > brick.y

            if isOverlapping then
                local horizontalOverlap = math.min(
                    self.ball.x + ballWidth - brick.x,
                    brick.x + brick.width - self.ball.x
                )
                local verticalOverlap = math.min(
                    self.ball.y + ballHeight - brick.y,
                    brick.y + brick.height - self.ball.y
                )

                if horizontalOverlap < verticalOverlap then
                    if self.ball.x < brick.x then
                        self.ball.x = brick.x - ballWidth
                        self.ball.x_velocity = -math.abs(self.ball.x_velocity)
                    else
                        self.ball.x = brick.x + brick.width
                        self.ball.x_velocity = math.abs(self.ball.x_velocity)
                    end
                else
                    if self.ball.y < brick.y then
                        self.ball.y = brick.y - ballHeight
                        self.ball.y_velocity = -math.abs(self.ball.y_velocity)
                    else
                        self.ball.y = brick.y + brick.height
                        self.ball.y_velocity = math.abs(self.ball.y_velocity)
                    end
                end

                brick:hit()
                GSounds['brick-hit-1']:play()
                break
            end
        end
    end
end

function RunningState:allBricksBroken()
    for _, brick in ipairs(self.bricks) do
        if brick.inPlay then
            return false
        end
    end

    return true
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

    self:checkPaddleCollision()
    self:checkBrickCollision()

    if self:allBricksBroken() then
        GStateMachine:change("gameOverState")
        return
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
    for _, brick in ipairs(self.bricks) do
        brick:render()
    end
    self.paddle:render()
    self.ball:render()
end
