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
    self.isPaused = false

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

    self.constructed_lanes = { {}, {}, {}, {} }

    for i, lane in ipairs(self.note_lanes) do
        for _, chartNote in ipairs(lane) do
            table.insert(
                self.constructed_lanes[i],
                Note(chartNote.start, chartNote.duration, DIRECTIONS[i])
            )
        end
    end
end

-- Use tween.lua to update y coordinates according to its time
function PlayState:update(dt)
    if love.keyboard.wasPressed("p") then
        if self.isPaused then
            self.levelSong:play()
            self.isPaused = false
        else
            self.levelSong:pause()
            self.isPaused = true
        end
        return
    end

    local seekTime = self.levelSong:tell("seconds")

    if love.keyboard.wasPressed("j") then
        seekTime = math.max(0, seekTime - 1)
    elseif love.keyboard.wasPressed("k") then
        seekTime = math.min(self.levelSong:getDuration("seconds"), seekTime + 1)
    else
        seekTime = nil
    end

    if seekTime then
        self.levelSong:seek(seekTime, "seconds")
        self.current_time = seekTime

        -- Re-sync note processing after seeking backward or forward.
        for lane_idx = 1, 4 do
            local lane = self.note_lanes[lane_idx]
            local active_i = 1

            while active_i <= #lane and lane[active_i].start < seekTime - 0.3 do
                active_i = active_i + 1
            end

            self.active_indices[lane_idx] = active_i
        end
    end

    if self.isPaused then
        return
    end

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
    for i, lane in ipairs(self.constructed_lanes) do
        for j, note in ipairs(lane) do
            local headY = self.hitZone_y
                - ((note.start - currentTime) * self.scroll_speed)
            local tailY = headY - (note.duration * self.scroll_speed)
            local bottomY = headY + (ARROW_HEIGHT * note.scale)

            if bottomY >= 0 and tailY <= VIRTUAL_HEIGHT then
                note:render(headY, self.scroll_speed)
            end
        end
    end

    ArrowsButtonBox:render()
    local totalMilliseconds = math.floor(currentTime * 1000)
    local minutes = math.floor(totalMilliseconds / 60000)
    local seconds = math.floor(totalMilliseconds / 1000) % 60
    local milliseconds = totalMilliseconds % 1000
    love.graphics.print(
        string.format("Music: %02d-%02d-%03d", minutes, seconds, milliseconds),
        10,
        10
    )
end
