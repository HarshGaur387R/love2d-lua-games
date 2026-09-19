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
            love.graphics.newQuad(8, 1, ARROW_WIDTH + 1, ARROW_HEIGHT, GSprites["Arrows"]),
            love.graphics.newQuad(8, 129, ARROW_WIDTH, ARROW_HEIGHT, GSprites["Arrows"]),
        }
    elseif direction == "right" then
        return {
            love.graphics.newQuad(117, 1, ARROW_WIDTH, ARROW_HEIGHT, GSprites["Arrows"]),
            love.graphics.newQuad(117, 129, ARROW_WIDTH, ARROW_HEIGHT, GSprites["Arrows"]),
        }
    elseif direction == "down" then
        return {
            love.graphics.newQuad(229, 22, ARROW_WIDTH, ARROW_HEIGHT, GSprites["Arrows"]),
            love.graphics.newQuad(229, 150, ARROW_WIDTH, ARROW_HEIGHT, GSprites["Arrows"]),
        }
    elseif direction == "up" then
        return {
            love.graphics.newQuad(373, 22, ARROW_WIDTH + 30, ARROW_HEIGHT, GSprites["Arrows"]),
            love.graphics.newQuad(373, 150, ARROW_WIDTH, ARROW_HEIGHT, GSprites["Arrows"]),
        }
    else
        return {}
    end
end
