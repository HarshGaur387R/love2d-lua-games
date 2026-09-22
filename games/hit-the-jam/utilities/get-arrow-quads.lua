require "src.constants"


--- @alias Direction
---| '"up"'
---| '"down"'
---| '"left"'
---| '"right"'

--- This function takes a direction and returns the generated quads of that direction
--- @param direction Direction
--- @return {}
function GetArrowQuads(direction)
    if direction == "left" then
        return {
            love.graphics.newQuad(132, 4, ARROW_WIDTH, ARROW_HEIGHT, GSprites["Arrows"]),
            love.graphics.newQuad(132, 132, ARROW_WIDTH, ARROW_HEIGHT, GSprites["Arrows"]),
        }
    elseif direction == "right" then
        return {
            love.graphics.newQuad(388, 4, ARROW_WIDTH, ARROW_HEIGHT, GSprites["Arrows"]),
            love.graphics.newQuad(388, 132, ARROW_WIDTH, ARROW_HEIGHT, GSprites["Arrows"]),
        }
    elseif direction == "down" then
        return {
            love.graphics.newQuad(260, 4, ARROW_WIDTH, ARROW_HEIGHT, GSprites["Arrows"]),
            love.graphics.newQuad(260, 132, ARROW_WIDTH, ARROW_HEIGHT, GSprites["Arrows"]),
        }
    elseif direction == "up" then
        return {
            love.graphics.newQuad(4, 4, ARROW_WIDTH, ARROW_HEIGHT, GSprites["Arrows"]),
            love.graphics.newQuad(4, 132, ARROW_WIDTH, ARROW_HEIGHT, GSprites["Arrows"]),
        }
    else
        return {}
    end
end
