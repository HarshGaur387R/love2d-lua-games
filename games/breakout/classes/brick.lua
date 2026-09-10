Brick = Object:extend()
require "utils.generateQuadBrick"

function Brick:new(x, y)
    self.x = x
    self.y = y
    self.brickQuad = GenerateQuadsBrick(GTextures['block'])
    local _, _, brickWidth, brickHeight = self.brickQuad:getViewport()
    self.width = brickWidth
    self.height = brickHeight
    self.inPlay = true
end

function Brick:hit()
    self.inPlay = false
end

function Brick:update(dt)

end

function Brick:render()
    if self.inPlay then
        love.graphics.draw(GTextures['block'], self.brickQuad, self.x, self.y)
    end
end
