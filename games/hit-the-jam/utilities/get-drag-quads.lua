require "src.constants"


--- @alias Direction
---| '"up"' -- Green
---| '"left"' -- Orange
---| '"down"' -- Blue
---| '"right"' -- Red

--- This function takes a direction and returns the generated quads of that direction
--- @param direction Direction
--- @return {}
function GetArrowQuads(direction)
    if direction == "up" then
        return {
            love.graphics.newQuad(31, 32, DRAG_WIDTH, DRAG_HEIGHT, GSprites["Drag"]),           -- drag body
            love.graphics.newQuad(31, 25, DRAG_HEAD_WIDTH, DRAG_HEAD_HEIGHT, GSprites["Drag"]), -- drag head
        }
    elseif direction == "left" then
        return {
            love.graphics.newQuad(159, 32, DRAG_WIDTH, DRAG_HEIGHT, GSprites["Drag"]),
            love.graphics.newQuad(159, 25, DRAG_HEAD_WIDTH, DRAG_HEAD_HEIGHT, GSprites["Drag"]),
        }
    elseif direction == "down" then
        return {
            love.graphics.newQuad(276, 32, DRAG_WIDTH, DRAG_HEIGHT, GSprites["Drag"]),
            love.graphics.newQuad(276, 25, DRAG_HEAD_WIDTH, DRAG_HEAD_HEIGHT, GSprites["Drag"]),
        }
    elseif direction == "right" then
        return {
            love.graphics.newQuad(415, 32, DRAG_WIDTH, DRAG_HEIGHT, GSprites["Drag"]),
            love.graphics.newQuad(415, 25, DRAG_HEAD_WIDTH, DRAG_HEAD_HEIGHT, GSprites["Drag"]),
        }
    else
        return {}
    end
end
