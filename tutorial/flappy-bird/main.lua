BASE_WIDTH = 512
BASE_HEIGHT = 288

function love.load()
    Object = require("classic")
    require "classes.Bird"
    require "classes.Pipe"
    Push = require "push"
    love.graphics.setDefaultFilter("linear", "linear")

    love.keyboard.keysPressed = {}

    Pipes = {} -- This table contains set of pipes eg. {{upPipe1, downPipe1}, {upPipe2, downPipe2}}
    PIPES_GAP = 100
    PIPES_SET_GAP = 400
    Timer = 0
    TIME_LIMIT = 3

    WINDOW_WIDTH = love.graphics.getWidth()
    WINDOW_HEIGHT = love.graphics.getHeight()

    -- Possible combinations of gap of pipeSets
    -- PIPE_SET_GAP_COMBOS = {{p1_y=}}

    Background_image = love.graphics.newImage('images/background.png')
    BackgroundScroll = 0
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

    local pipe1 = Pipe(BASE_WIDTH, BASE_HEIGHT / 2, false)
    local pipe2 = Pipe(BASE_WIDTH, BASE_HEIGHT / 2, true)
    table.insert(Pipes, { p1 = pipe1, p2 = pipe2 })
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
    if BackgroundScroll >= BACKGROUND_LOOP_POINT then
        BackgroundScroll = 0
    end

    if GROUND_SCROLL >= BASE_WIDTH then
        GROUND_SCROLL = 0
    end

    BackgroundScroll = BackgroundScroll + BACKGROUND_SCROLL_SPEED * dt
    GROUND_SCROLL = GROUND_SCROLL + GROUND_SCROLL_SPEED * dt

    -- Inserting new set of pipe every 2 seconds
    Timer = Timer + dt
    if Timer > TIME_LIMIT then
        local pipe1 = Pipe(BASE_WIDTH, BASE_HEIGHT / 2, false)
        local pipe2 = Pipe(BASE_WIDTH, BASE_HEIGHT / 2, true)
        table.insert(Pipes, { p1 = pipe1, p2 = pipe2 })
        Timer = 0
    end

    for index, set_of_pipe in ipairs(Pipes) do
        set_of_pipe.p1:update(dt)
        set_of_pipe.p2:update(dt)

        if set_of_pipe.p1.x + set_of_pipe.p1.image:getWidth() < 0 then
            table.remove(Pipes, index)
        end
    end

    Flappy_bird:update(dt)

    -- Empty keysPressed table at every update.
    love.keyboard.keysPressed = {}
end

function love.draw()
    Push:apply("start")
    love.graphics.clear(1, 1, 1, 1)

    -- Background image
    love.graphics.draw(Background_image, -BackgroundScroll, 0)

    -- Path Image
    love.graphics.draw(Ground_image, -GROUND_SCROLL, BASE_HEIGHT - Ground_image:getHeight())

    Flappy_bird:draw()

    for _, pipeSet in ipairs(Pipes) do
        pipeSet.p1:draw()
        pipeSet.p2:draw()
    end

    -- Show number of pipes on screen
    love.graphics.print("Pipes: " .. #Pipes, 10, 10)

    Push:apply("end")
end
