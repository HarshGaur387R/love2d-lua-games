local push = require("libs.push")

---@class Arrow:Object
Drag = Object:extend()

---@param x number
---@param y number
---@param isActive boolean
---@param dragType string
---@param height number
function Drag:new(y_start, height, isActive, dragType)
    self.scale = 0.6
    self.x = NOTE_LANE_X_CORD[dragType] + ((ARROW_WIDTH - DRAG_WIDTH) * self.scale / 2)
    self.y = y_start
    self.height = height
    self.active = isActive
    self.dragType = dragType

    local quads = GetDragQuads(dragType, 1) -- second parameters is height in px(pixels)

    self.body = quads[1]
    self.tail = quads[2]
end

---@param dt number
function Drag:update(dt)
    if GStateMachine.currentStateName == "play" then
    end
end

function Drag:render()
    local bodyY = self.y + DRAG_TAIL_HEIGHT * self.scale

    if self.active then
        love.graphics.draw(GSprites["Drag"], self.tail, self.x, self.y, 0, self.scale)

        for i = 0, self.height + DRAG_FILLER_HEIGHT - 1, 1 do
            love.graphics.draw(
                GSprites["Drag"],
                self.body,
                self.x,
                bodyY + i * self.scale,
                0,
                self.scale
            )
        end
    end
end
