require "utils.generateQuadsHearts"

HealthBar = Object:extend()

function HealthBar:new()
    self.x = VIRTUAL_WIDTH - 50
    self.y = 5
    self.gap = 11
    self.totalHearts = 3
    self.remainingHearts = 3
    self.heartQuad = GenerateQuadsHearts(GTextures['main'], 128, 48)
    self.emptyHeartQuad = GenerateQuadsHearts(GTextures['main'], 138, 48)
    local _, _, heartWidth = self.heartQuad:getViewport()
    self.heartWidth = heartWidth
end

function HealthBar:render()
    local tempX = self.x
    for i = 1, self.remainingHearts, 1 do
        love.graphics.draw(GTextures['main'], self.heartQuad, tempX, self.y)
        tempX = tempX + self.gap
    end

    tempX = self.x + 22

    for i = 1, math.abs(self.totalHearts - self.remainingHearts), 1 do
        love.graphics.draw(GTextures['main'], self.emptyHeartQuad, tempX, self.y)
        tempX = math.abs(tempX - self.gap)
    end

    tempX = self.x
end
