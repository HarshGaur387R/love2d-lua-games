---@class MarginBox:Object
---By default MarginBox will spread out the elements inside it and takes full space.
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

    local number_of_elements = #self.elements

    if number_of_elements > 1 then
        local elementWidth = ARROW_WIDTH
        local total_gap = 0
        local i = 0
        local left_pad = 3
        -- run gapping algorithm if there are more than one elements

        for _, element in ipairs(self.elements) do
            if i > 0 and i < number_of_elements then
                total_gap = self.gap * i
            end

            if i == number_of_elements then
                total_gap = 0
            end
            element.x = left_pad + total_gap + (elementWidth * element.scale) * i
            i = i + 1
        end
    end
end

---@param element any
---Adds an element in the margin box with the other elements.
---Elements should contain a render function and x, y cords
function MarginBox:add(element)

end

function MarginBox:update(dt)
    for _, element in ipairs(self.elements) do
        element:update(dt)
    end
end

---Renders all the element at the calculated positions.
function MarginBox:render()
    for _, element in ipairs(self.elements) do
        element:render()
    end
end
