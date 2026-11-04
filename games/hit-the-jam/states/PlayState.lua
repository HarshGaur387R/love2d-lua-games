require "states.BaseState"
require "classes.Arrow"
require "classes.MarginBox"
require "classes.Note"
local JSON = require "utilities.decode-json"

-- These are hard coded coordinates
PlayState = BaseState:extend()

function PlayState:enter()
    local Y_Constant = 30
    local json_path = CurrentChapter["levels"][CurrentLevel]["json_data"]
    local text, read_error = love.filesystem.read(json_path)
    assert(text, string.format("Unable to open level data '%s': %s", json_path, read_error))

    local level_data, decode_error = JSON.decode(text)
    assert(level_data, string.format("Unable to decode level data '%s': %s", json_path, decode_error))
    self.levelData = level_data

    local level_song_path = CurrentChapter["levels"][CurrentLevel]["song"]
    self.levelSong = love.audio.newSource(level_song_path, "static")

    -- StrumLines has 2 arrays for player 1 and player 2
    -- note_lanes contains four lane and each lane has multiple notes
    self.note_lanes = self.levelData.strumLines[1]
    self.scroll_speed = 800
    self.hitZone_y = 547
    self.active_indices = { 1, 1, 1, 1 }

    self.levelSong:play()

    -- Assigning Arrow Buttons
    LeftArrow = Arrow(10, VIRTUAL_HEIGHT - ARROW_HEIGHT + Y_Constant, GetArrowQuads("left"), false, "left",
        function() end)
    DownArrow = Arrow(90, VIRTUAL_HEIGHT - ARROW_HEIGHT + Y_Constant, GetArrowQuads("down"), false, "down",
        function() end)
    UpArrow = Arrow(180, VIRTUAL_HEIGHT - ARROW_HEIGHT + Y_Constant, GetArrowQuads("up"), false, "up",
        function() end)
    RightArrow = Arrow(270, VIRTUAL_HEIGHT - ARROW_HEIGHT + Y_Constant, GetArrowQuads("right"), false, "right",
        function() end)


    -- Assigning them to MarginBox
    ArrowsButtonBox = MarginBox("bottom-horizontal",
        { leftPad = 10, rightPad = 10, bottomPad = 0, topPad = 0 },
        20,
        { LeftArrow, DownArrow, UpArrow, RightArrow }
    )

    self.left_notes = {}

    for _, chartNote in ipairs(self.note_lanes[1]) do
        table.insert(
            self.left_notes,
            Note(chartNote.start, chartNote.duration, "left")
        )
    end
end

-- Use tween.lua to update y coordinates according to its time
function PlayState:update(dt)
    ArrowsButtonBox:update(dt)
    self.current_time = self.levelSong:tell("seconds")

    for lane_idx = 1, 4 do
        local notes_in_lane = self.note_lanes[lane_idx]
        local active_i = self.active_indices[lane_idx]

        while active_i <= #notes_in_lane do
            local note = notes_in_lane[active_i]

            -- note.start is same as note.time but it makes more sense when used with duration
            local time_diff = note.start - self.current_time

            -- Missed note check (passed hit zone by 0.3)
            if time_diff < -0.3 then
                if not note.was_hit then
                    -- self:on_miss(note, lane_idx)
                end
                active_i = active_i + 1
            else
                break
            end
        end

        self.active_indices[lane_idx] = active_i
    end
end

function PlayState:render()
    local currentTime = self.levelSong:tell("seconds")

    for _, note in ipairs(self.left_notes) do
        local headY = self.hitZone_y
            - ((note.start - currentTime) * self.scroll_speed)
        local tailY = headY - (note.duration * self.scroll_speed)
        local bottomY = headY + (ARROW_HEIGHT * note.scale)

        if bottomY >= 0 and tailY <= VIRTUAL_HEIGHT then
            note:render(headY, self.scroll_speed)
        end
    end

    ArrowsButtonBox:render()
end

--[[ function PlayState:render()
    ArrowsButtonBox:render()

    local lane_arrows = { LeftArrow, DownArrow, UpArrow, RightArrow }

    for lane_idx = 1, 4 do
        local notes_in_lane = self.note_lanes[lane_idx]
        local lane_arrow = lane_arrows[lane_idx]

        for i = self.active_indices[lane_idx], #notes_in_lane do
            local note = notes_in_lane[i]
            local time_diff = note.start - self.current_time
            local note_y = self.hitZone_y - (time_diff * self.scroll_speed)

            if note_y < -100 then
                break
            elseif note_y <= VIRTUAL_HEIGHT + 100 then
                love.graphics.draw(
                    GSprites["Arrows"],
                    lane_arrow.unActiveQuad,
                    lane_arrow.x,
                    note_y,
                    0,
                    lane_arrow.scale
                )
            end
        end
    end
    -- love.graphics.printf(#self.level[4], 0, 130, 100)
end ]]
