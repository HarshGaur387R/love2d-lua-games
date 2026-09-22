---@class Arrow:Object
Arrow = Object:extend()

---@param x number
---@param y number
---@param quads {}
---@param isActive boolean
---@param onClick function
---@param arrowType string
function Arrow:new(x, y, quads, isActive, arrowType, onClick)
    self.x = x
    self.y = y
    self.activeQuad = quads[2]
    self.unActiveQuad = quads[1]
    self.callback = onClick
    self.active = isActive
    self.arrowType = arrowType
    self.scale = 0.6
end

---@param dt number
function Arrow:update(dt)
    if GStateMachine.currentStateName == "play" then
        if love.keyboard.wasPressed(self.arrowType) then
            self.active = true
        end

        if love.keyboard.wasReleased(self.arrowType) then
            self.active = false
        end
    end
end

function Arrow:render()
    if self.active then
        love.graphics.draw(GSprites["Arrows"], self.activeQuad, self.x, self.y, 0, self.scale)
    else
        love.graphics.draw(GSprites["Arrows"], self.unActiveQuad, self.x, self.y, 0, self.scale)
    end
end
