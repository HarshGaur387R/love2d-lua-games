LevelMaker = Object:extend()
require "classes.brick"

function LevelMaker:CreateMap(level)
    local bricks = {}

    if level == 1 then
        local brickWidth = 31
        local brickHeight = 15
        local brickSpacing = 1
        local columns = 13
        local rows = 5
        local startX = (VIRTUAL_WIDTH - columns * brickWidth - (columns - 1) * brickSpacing) / 2
        local startY = 20

        for row = 0, rows - 1 do
            for column = 0, columns - 1 do
                local x = startX + column * (brickWidth + brickSpacing)
                local y = startY + row * (brickHeight + brickSpacing)
                table.insert(bricks, Brick(x, y))
            end
        end
    end

    return bricks
end
