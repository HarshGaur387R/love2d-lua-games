require "classes.Arrow"
require "classes.Drag"
require "utilities.get-arrow-quads"
require "utilities.get-drag-quads"
require "src.constants"

Note = Object:extend()

---@param start number
---@param duration number
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
        start + (DRAG_TAIL_HEIGHT + duration) * 0.6,
        GetArrowQuads(type),
        false, type,
        function() end)

    self.drag     = nil

    -- if duration is greater than 200ms then create a drag in note
    if duration >= 200 then
        self.drag = Drag(start, duration, true, type)
    end
end

function Note:update(dt)

end

function Note:render()
    if self.drag then
        self.drag:render()
    end
    self.head:render()
end
