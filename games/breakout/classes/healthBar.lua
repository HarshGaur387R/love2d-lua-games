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
end

function HealthBar:render()
    local tempX = self.x
    for i = 1, self.remainingHearts, 1 do
        love.graphics.draw(GTextures['main'], self.heartQuad, tempX, self.y)
        tempX = tempX + self.gap
    end
    tempX = 0
end
