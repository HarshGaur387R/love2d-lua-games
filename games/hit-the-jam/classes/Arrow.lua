---@class Arrow:Object
Arrow = Object:extend()

---@param x number
---@param y number
---@param quads {}
---@param onClick function
function Arrow:new(x, y, quads, onClick)
    self.x = x
    self.y = y
    self.unActiveQuad = quads[1]
    self.activeQuad = quads[2]
    self.callback = onClick
end

---@param dt number
function Arrow:update(dt)

end

function Arrow:render()
    love.graphics.draw(GSprites["Arrows"], self.unActiveQuad, self.x, self.y, 0, 0.6)
end
