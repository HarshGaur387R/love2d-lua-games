local push = require("libs.push")
require "src.Dependencies"

local pixelFont

function love.load()
    love.graphics.setDefaultFilter("nearest", "nearest")
    pixelFont = love.graphics.newFont("assets/fonts/font.ttf", 32)

    push.setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, {
        upscale = "normal",
        canvas = false
    })

    GSprites = {
        ["Arrows"] = love.graphics.newImage("assets/images/arrow-buttons.png")
    }

    UpArrow = Arrow(10, VIRTUAL_HEIGHT - ARROW_HEIGHT, GetArrowQuads("up"), function() end)
    LeftArrow = Arrow(90, VIRTUAL_HEIGHT - ARROW_HEIGHT, GetArrowQuads("left"), function() end)
    DownArrow = Arrow(180, VIRTUAL_HEIGHT - ARROW_HEIGHT, GetArrowQuads("down"), function() end)
    RightArrow = Arrow(270, VIRTUAL_HEIGHT - ARROW_HEIGHT, GetArrowQuads("right"), function() end)

    ArrowsButtonBox = MarginBox("bottom-horizontal",
        { leftPad = 10, rightPad = 10, bottomPad = 0, topPad = 0 },
        20,
        { UpArrow, LeftArrow, DownArrow, RightArrow }
    )
end

function love.resize(width, height)
    push.resize(width, height)
end

function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    end
end

function love.draw()
    love.graphics.clear(0, 1, 0, 1) -- green, background color testing only

    push.start()
    love.graphics.clear(1, 0, 0, 1) -- red, canvas color, testing only
    love.graphics.setFont(pixelFont)

    ArrowsButtonBox:render()
    -- UpArrow:render()
    -- LeftArrow:render()
    -- DownArrow:render()
    -- RightArrow:render()
    push.finish()
end
