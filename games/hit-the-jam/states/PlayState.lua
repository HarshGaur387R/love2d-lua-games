require "states.BaseState"
require "classes.Arrow"
require "classes.MarginBox"
local JSON = require "utilities.decode-json"

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
    self.levelSong:play()

    -- Assigning Arrow Buttons
    UpArrow = Arrow(10, VIRTUAL_HEIGHT - ARROW_HEIGHT + Y_Constant, GetArrowQuads("up"), false, "up", function() end)
    LeftArrow = Arrow(90, VIRTUAL_HEIGHT - ARROW_HEIGHT + Y_Constant, GetArrowQuads("left"), false, "left",
        function() end)
    DownArrow = Arrow(180, VIRTUAL_HEIGHT - ARROW_HEIGHT + Y_Constant, GetArrowQuads("down"), false, "down",
        function() end)
    RightArrow = Arrow(270, VIRTUAL_HEIGHT - ARROW_HEIGHT + Y_Constant, GetArrowQuads("right"), false, "right",
        function() end)

    -- Assigning them to MarginBox
    ArrowsButtonBox = MarginBox("bottom-horizontal",
        { leftPad = 10, rightPad = 10, bottomPad = 0, topPad = 0 },
        20,
        { UpArrow, LeftArrow, DownArrow, RightArrow }
    )
end

function PlayState:update(dt)
    ArrowsButtonBox:update(dt)
end

function PlayState:render()
    love.graphics.printf(self.levelData.bpm, 0, 100, 100)
    ArrowsButtonBox:render()
end
