local push = require("libs.push")

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
    self.activeTouchId = nil
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

        local pressedTouches = love.touch.pressedTouches

        for _, touchId in ipairs(pressedTouches) do
            local screenX, screenY = love.touch.getPosition(touchId)
            local x, y = push.toGame(screenX, screenY)

            if type(x) == "number" and type(y) == "number" then
                if x > self.x and x < self.x + ARROW_WIDTH * self.scale and y > self.y and y < self.y + ARROW_HEIGHT * self.scale then
                    self.active = true
                    self.activeTouchId = touchId
                end
            end
        end

        local releasedTouches = love.touch.releasedTouches

        for _, touch in ipairs(releasedTouches) do
            if touch.id == self.activeTouchId then
                self.active = false
                self.activeTouchId = nil
            end
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
