require "classes.Arrow"
require "classes.Drag"
require "utilities.get-arrow-quads"
require "utilities.get-drag-quads"
require "src.constants"

Note = Object:extend()

---@param start number Song time in seconds when the arrow reaches the hit zone
---@param duration number Hold duration in seconds
---@param type string -- left, right, up and down
function Note:new(start, duration, type)
    self.start    = start
    self.duration = duration
    self.type     = type
    self.active   = true
    self.isHold   = false
    self.scale    = 0.6
    self.head     = Arrow(
        NOTE_LANE_X_CORD[type],
        0,
        GetArrowQuads(type),
        false, type,
        function() end)

    self.drag     = nil

    if duration > 0 then
        self.drag = Drag(true, type)
    end
end

function Note:update(dt)

end

function Note:render(headY, scrollSpeed)
    self.head.y = headY

    if self.active then
        if self.drag then
            local length = self.duration * scrollSpeed
            self.drag:render(headY - length, length)
        end

        self.head:render()
    end
end
