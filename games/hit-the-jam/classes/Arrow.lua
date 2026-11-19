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
    self.pressed = false
    self.arrowType = arrowType
    self.scale = 0.6
end

---@param dt number
function Arrow:update(dt)
    self.pressed = love.keyboard.wasPressed(self.arrowType)

    for _, touch in ipairs(love.touch.pressedTouches) do
        if type(touch.x) == "number" and type(touch.y) == "number" then
            local x, y = push.toGame(touch.x, touch.y)

            if type(x) == "number" and type(y) == "number"
                and x > self.x and x < self.x + ARROW_WIDTH * self.scale
                and y > self.y and y < self.y + ARROW_HEIGHT * self.scale then
                self.pressed = true
            end
        end
    end

    if GStateMachine.currentStateName == "play" then
        self.active = love.keyboard.isDown(self.arrowType)

        for _, touchId in ipairs(love.touch.getTouches()) do
            local screenX, screenY = love.touch.getPosition(touchId)
            local x, y = push.toGame(screenX, screenY)

            if type(x) == "number" and type(y) == "number" then
                if x > self.x and x < self.x + ARROW_WIDTH * self.scale and y > self.y and y < self.y + ARROW_HEIGHT * self.scale then
                    self.active = true
                end
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
