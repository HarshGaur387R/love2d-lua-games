require "states.BaseState"
require "classes.Arrow"
require "classes.MarginBox"
require "classes.Note"
local JSON = require "utilities.decode-json"

local PERFECT_WINDOW = 0.05
local JUDGMENT_DURATION = 0.8
local JUDGMENT_RISE = 45
local JUDGMENT_FONT_SIZE = 16
local JUDGMENT_COLORS = {
    Perfect = { 0.35, 1, 0.55 },
    Early = { 0.35, 0.8, 1 },
    Late = { 1, 0.7, 0.3 },
    Miss = { 1, 0.3, 0.3 }
}

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
    self.hitMessages = {}
    self.judgmentFont = love.graphics.newFont("assets/fonts/font.ttf", JUDGMENT_FONT_SIZE)

    local highlightPixelData = love.image.newImageData(1, 1)
    highlightPixelData:setPixel(0, 0, 1, 1, 1, 1)
    self.highlightPixel = love.graphics.newImage(highlightPixelData)
    self.highlightPixel:setFilter("nearest", "nearest")

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
    self.arrowButtons = { LeftArrow, DownArrow, UpArrow, RightArrow }

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

    for lane_idx, hitMessage in pairs(self.hitMessages) do
        hitMessage.elapsed = hitMessage.elapsed + dt
        local progress = math.min(hitMessage.elapsed / JUDGMENT_DURATION, 1)
        hitMessage.y = hitMessage.startY - JUDGMENT_RISE * progress
        hitMessage.alpha = 1 - progress
        if progress >= 1 then
            self.hitMessages[lane_idx] = nil
        end
    end

    for lane_idx, button in ipairs(self.arrowButtons) do
        local note_index = self.active_indices[lane_idx]
        local note = self.note_lanes[lane_idx][note_index]
        local visual_note = self.constructed_lanes[lane_idx][note_index]

        if note and not note.was_hit then
            if visual_note.drag then
                if button.pressed and not note.hold_started and not note.hold_failed
                    and math.abs(note.start - self.current_time) <= 0.2 then
                    note.hold_started = true
                    note.hold_judgment = self:getJudgment(self.current_time - note.start)
                    self.hitMessages[lane_idx] = nil
                end

                if note.hold_started then
                    if not button.active then
                        note.hold_started = false
                        note.hold_failed = true
                        visual_note.active = false
                        self:showJudgment(lane_idx, visual_note, "Miss")
                    elseif self.current_time >= note.start + note.duration then
                        note.was_hit = true
                        visual_note.active = false
                        self:showJudgment(lane_idx, visual_note, note.hold_judgment)
                    end
                end
            elseif button.pressed and math.abs(note.start - self.current_time) <= 0.2 then
                note.was_hit = true
                visual_note.active = false
                self:showJudgment(
                    lane_idx,
                    visual_note,
                    self:getJudgment(self.current_time - note.start)
                )
            end
        end
    end

    for lane_idx = 1, 4 do
        local notes_in_lane = self.note_lanes[lane_idx]
        local active_i = self.active_indices[lane_idx]

        while active_i <= #notes_in_lane do
            local note = notes_in_lane[active_i]

            if note.was_hit or note.hold_failed then
                active_i = active_i + 1
            elseif note.hold_started then
                break
            else
                -- note.start is same as note.time but it makes more sense when used with duration
                local time_diff = note.start - self.current_time

                -- Missed note check (passed hit zone by 0.3)
                if time_diff < -0.3 then
                    self:showJudgment(
                        lane_idx,
                        self.constructed_lanes[lane_idx][active_i],
                        "Miss"
                    )
                    self.constructed_lanes[lane_idx][active_i].active = false
                    active_i = active_i + 1
                else
                    break
                end
            end
        end

        self.active_indices[lane_idx] = active_i
    end
end

function PlayState:getJudgment(offset)
    if math.abs(offset) <= PERFECT_WINDOW then
        return "Perfect"
    elseif offset < 0 then
        return "Early"
    end

    return "Late"
end

function PlayState:showJudgment(lane_idx, visual_note, judgment)
    self.hitMessages[lane_idx] = {
        text = judgment,
        color = JUDGMENT_COLORS[judgment],
        x = visual_note.head.x,
        y = self.hitZone_y - 30,
        startY = self.hitZone_y - 30,
        width = ARROW_WIDTH * visual_note.head.scale,
        elapsed = 0,
        alpha = 1
    }
end

function PlayState:render()
    local currentTime = self.levelSong:tell("seconds")

    local anyActive = false
    for _, button in ipairs(self.arrowButtons) do
        if button.active then
            anyActive = true; break
        end
    end
    local trace = anyActive and not self._traceWasActive
    self._traceWasActive = anyActive
    if trace then print("[render-trace] before highlight") end


    -- Highlighting active button lane.
    for i, button in ipairs(self.arrowButtons) do
        if button.active then
            local color = ARROW_COLOR_VALUES[DIRECTIONS[i]]
            local shade = 0.25
            love.graphics.setColor(
                color[1] * shade,
                color[2] * shade,
                color[3] * shade,
                1
            )
            love.graphics.draw(
                self.highlightPixel,
                button.x,
                0,
                0,
                ARROW_WIDTH * button.scale,
                VIRTUAL_HEIGHT
            )
        end
    end


    if trace then print("[render-trace] after highlight") end

    -- Render color reset here.
    love.graphics.setColor(1, 1, 1, 1)


    -- Rendering falling notes.
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

    if trace then print("[render-trace] after notes") end

    -- Rendering arrow buttons.
    ArrowsButtonBox:render()

    if trace then print("[render-trace] after arrows") end

    local totalMilliseconds = math.floor(currentTime * 1000)
    local minutes = math.floor(totalMilliseconds / 60000)
    local seconds = math.floor(totalMilliseconds / 1000) % 60
    local milliseconds = totalMilliseconds % 1000
    love.graphics.print(
        string.format("Music: %02d-%02d-%03d", minutes, seconds, milliseconds),
        10,
        10
    )

    -- Drawing hit message
    local currentFont = love.graphics.getFont()
    love.graphics.setFont(self.judgmentFont)
    for _, hitMessage in pairs(self.hitMessages) do
        local color = hitMessage.color
        love.graphics.setColor(color[1], color[2], color[3], hitMessage.alpha)
        love.graphics.printf(
            hitMessage.text,
            hitMessage.x,
            hitMessage.y,
            hitMessage.width,
            "center"
        )
    end
    love.graphics.setFont(currentFont)

    love.graphics.setColor(0, 1, 0, 1)
end
