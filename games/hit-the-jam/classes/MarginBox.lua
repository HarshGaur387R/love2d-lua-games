---@class MarginBox:Object
---By default MarginBox will spread out the elements inside it.
MarginBox = Object:extend()

---@alias Type
---| "top-horizontal"
---| "top-vertical"
---| "middle-horizontal"
---| "middle-vertical"
---| "bottom-horizontal"
---| "bottom-vertical"


---@param type Type
---@param padding {leftPad:number, rightPad:number, topPad:number, bottomPad:number}
---@param gap number
---@param elements {}
function MarginBox:new(type, padding, gap, elements)
    self.type = type
    self.padding = padding
    self.gap = gap
    self.elements = elements

    if #self.elements > 1 then
        -- run gapping algorithm if there are more than one elements
    end
end

---@param element any
---Adds an element in the margin box with the other elements.
---Elements should contain a render function and x, y cords
function MarginBox:add(element)

end

---Renders all the element at the calculated positions.
function MarginBox:render()

end
