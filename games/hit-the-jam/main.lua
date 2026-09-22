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
    GStateMachine = StateMachine {
        ["play"] = function() return PlayState() end
    }

    GStateMachine:change("play")
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

    GStateMachine:render()
    push.finish()
end
