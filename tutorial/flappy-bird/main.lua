BASE_WIDTH = 512
BASE_HEIGHT = 288

function love.load()
    Object = require("classic")
    require "classes.Bird"
    Push = require "push"

    love.keyboard.keysPressed = {}

    love.graphics.setDefaultFilter("linear", "linear")

    WINDOW_WIDTH = love.graphics.getWidth()
    WINDOW_HEIGHT = love.graphics.getHeight()

    Background_image = love.graphics.newImage('images/background.png')
    BACKGROUND_SCROLL = 0
    BACKGROUND_LOOP_POINT = 413
    BACKGROUND_SCROLL_SPEED = 30

    Ground_image = love.graphics.newImage('images/ground.png')
    GROUND_SCROLL = 0
    GROUND_SCROLL_SPEED = 60

    Push:setupScreen(BASE_WIDTH, BASE_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = true,
        pixelperfect = false,
        highdpi = true
    })

    Flappy_bird = Bird(BASE_WIDTH / 2, BASE_HEIGHT / 2)
end

function love.resize(w, h)
    WINDOW_WIDTH = w
    WINDOW_HEIGHT = h
    Push:resize(w, h)
end

function love.keypressed(key)
    love.keyboard.keysPressed[key] = true

    if key == "escape" then
        love.event.quit()
    end
end

love.keyboard.wasPressed = function(key)
    if love.keyboard.keysPressed[key] then
        return true
    else
        return false
    end
end

function love.update(dt)
    if BACKGROUND_SCROLL >= BACKGROUND_LOOP_POINT then
        BACKGROUND_SCROLL = 0
    end

    if GROUND_SCROLL >= BASE_WIDTH then
        GROUND_SCROLL = 0
    end

    BACKGROUND_SCROLL = BACKGROUND_SCROLL + BACKGROUND_SCROLL_SPEED * dt
    GROUND_SCROLL = GROUND_SCROLL + GROUND_SCROLL_SPEED * dt

    Flappy_bird:update(dt)

    love.keyboard.keysPressed = {}
end

function love.draw()
    Push:apply("start")
    love.graphics.clear(1, 1, 1, 1)

    -- Background image
    love.graphics.draw(Background_image, -BACKGROUND_SCROLL, 0)

    -- Path Image
    love.graphics.draw(Ground_image, -GROUND_SCROLL, BASE_HEIGHT - Ground_image:getHeight())

    Flappy_bird:draw()

    Push:apply("end")
end
