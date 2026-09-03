Ball = Object:extend()

function Ball:new(ballQuad)
    self.ballQuad = ballQuad
    local _, _, ballWidth = self.ballQuad:getViewport()
    self.ballWidth = ballWidth
    self.x = (VIRTUAL_WIDTH / 2) - 3
    self.y = (VIRTUAL_HEIGHT / 2) + 95
    self.x_velocity = 0
    self.y_velocity = 0
end

function Ball:update(dt)
    if GStateMachine.currentStateName == "playState" then
        if love.keyboard.isDown('left') then
            self.x = self.x - 150 * dt
            if self.x <= 0 then
                self.x = 0
            end
        elseif love.keyboard.isDown('right') then
            self.x = self.x + 150 * dt
            if self.x >= VIRTUAL_WIDTH - self.ballWidth then
                self.x = VIRTUAL_WIDTH - self.ballWidth
            end
        end
    elseif GStateMachine.currentStateName == "runningState" then
        self.y = self.y + self.y_velocity * dt
        self.x = self.x + self.x_velocity * dt
    end
end

function Ball:reset()
    self.x = (VIRTUAL_WIDTH / 2) - 3
    self.y = (VIRTUAL_HEIGHT / 2) + 95
end

function Ball:render()
    love.graphics.draw(GTextures['main'], self.ballQuad, self.x, self.y)
end
