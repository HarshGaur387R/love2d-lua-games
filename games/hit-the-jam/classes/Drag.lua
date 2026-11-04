local push = require("libs.push")

---@class Arrow:Object
Drag = Object:extend()

---@param isActive boolean
---@param dragType string
function Drag:new(isActive, dragType)
    self.scale = 0.6
    self.x = NOTE_LANE_X_CORD[dragType] + ((ARROW_WIDTH - DRAG_WIDTH) * self.scale / 2)
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

function Drag:render(tailY, length)
    local tailHeight = DRAG_TAIL_HEIGHT * self.scale
    local bodyY = tailY + tailHeight
    local bodyLength = math.max(0, length - tailHeight)
    local bodyRows = math.ceil(bodyLength / self.scale)

    love.graphics.draw(GSprites["Drag"], self.tail, self.x, tailY, 0, self.scale)

    for i = 0, bodyRows - 1 do
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
