require "classes.Arrow"

-- These are hard coded coordinates
local X_COORDINATES = {
    3,
    96.8,
    190.6,
    284.4
}

function Level_Generator(strum_lines)
    local Y_Constant = 30

    local notes = {}

    for i, lane in ipairs(strum_lines) do
        notes[i] = {}

        for j, note in ipairs(lane) do
            local spawn_y = 0 + Y_Constant

            notes[i][j] = Arrow(
                X_COORDINATES[i],
                spawn_y,
                GetArrowQuads(DIRECTIONS[tonumber(i)]),
                false,
                DIRECTIONS[tonumber(i)],
                function() end
            )
        end
    end

    return notes
end
