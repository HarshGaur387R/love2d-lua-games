require "src.constants"


--- @alias Direction
---| '"up"' -- Green
---| '"left"' -- Orange
---| '"down"' -- Blue
---| '"right"' -- Red

--- This function takes a direction and returns the generated quads of that direction
--- @param direction Direction
--- @return {}
function GetDragQuads(direction, custom_height)
    local height = custom_height or DRAG_HEIGHT
    if direction == "up" then
        return {
            love.graphics.newQuad(31, 32, DRAG_WIDTH, height, GSprites["Drag"]),                -- drag body
            love.graphics.newQuad(31, 25, DRAG_TAIL_WIDTH, DRAG_TAIL_HEIGHT, GSprites["Drag"]), -- drag tail
        }
    elseif direction == "left" then
        return {
            love.graphics.newQuad(159, 32, DRAG_WIDTH, height, GSprites["Drag"]),
            love.graphics.newQuad(159, 25, DRAG_TAIL_WIDTH, DRAG_TAIL_HEIGHT, GSprites["Drag"]),
        }
    elseif direction == "down" then
        return {
            love.graphics.newQuad(287, 32, DRAG_WIDTH, height, GSprites["Drag"]),
            love.graphics.newQuad(287, 25, DRAG_TAIL_WIDTH, DRAG_TAIL_HEIGHT, GSprites["Drag"]),
        }
    elseif direction == "right" then
        return {
            love.graphics.newQuad(415, 32, DRAG_WIDTH, height, GSprites["Drag"]),
            love.graphics.newQuad(415, 25, DRAG_TAIL_WIDTH, DRAG_TAIL_HEIGHT, GSprites["Drag"]),
        }
    else
        return {}
    end
end
