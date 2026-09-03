Paddle = Object:extend()

function Paddle:new(paddleQuad)
    self.paddleQuad = paddleQuad
    local _, _, paddleWidth = self.paddleQuad:getViewport()
    self.paddleWidth = paddleWidth
    self.x = VIRTUAL_WIDTH / 2 - paddleWidth / 2
    self.y = VIRTUAL_HEIGHT - 20
    self.velocity = 150
end

function Paddle:update(dt)
    if GStateMachine.currentStateName == "playState" or GStateMachine.currentStateName == "runningState" then
        if love.keyboard.isDown('left') then
            self.x = self.x - self.velocity * dt
            if self.x <= 0 then
                self.x = 0
            end
        elseif love.keyboard.isDown('right') then
            self.x = self.x + self.velocity * dt
            if self.x >= VIRTUAL_WIDTH - self.paddleWidth then
                self.x = VIRTUAL_WIDTH - self.paddleWidth
            end
        end
    end
end

function Paddle:render()
    love.graphics.draw(GTextures['main'], self.paddleQuad, self.x, self.y)
end
