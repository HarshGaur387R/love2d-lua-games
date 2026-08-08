BASE_WIDTH = 512
BASE_HEIGHT = 288

function love.load()
    Object = require("classic")
    require "classes.Bird"
    require "classes.Pipe"
    Push = require "push"
    love.graphics.setDefaultFilter("linear", "linear")
    math.randomseed(os.time())

    love.keyboard.keysPressed = {}

    Pipes = {} -- This table contains set of pipes eg. {{upPipe1, downPipe1}, {upPipe2, downPipe2}}
    PIPES_SET_GAP = 100
    PIPE_GAP = 80

    WINDOW_WIDTH = love.graphics.getWidth()
    WINDOW_HEIGHT = love.graphics.getHeight()

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
    MINIMUM_PIPE_HEIGHT = 50

    local pipe1 = Pipe(BASE_WIDTH, 0 + MINIMUM_PIPE_HEIGHT, true)            -- Upper pipe
    local pipe2 = Pipe(BASE_WIDTH, BASE_HEIGHT - MINIMUM_PIPE_HEIGHT, false) --Lower pipe
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

    -- If the distance is equals to the given gap then
    Last_set_distance = BASE_WIDTH - (Pipes[#Pipes].p1.x + Pipes[#Pipes].p1.image:getWidth())

    if math.floor(Last_set_distance) == PIPES_SET_GAP then
        local upperY = math.random(MINIMUM_PIPE_HEIGHT, BASE_HEIGHT - MINIMUM_PIPE_HEIGHT)
        local pipe1 = Pipe(BASE_WIDTH, upperY - PIPE_GAP/2, true) -- Upper pipe

        local available_space = (BASE_HEIGHT - MINIMUM_PIPE_HEIGHT) - upperY
        local pipe2 = Pipe(BASE_WIDTH, (BASE_HEIGHT - MINIMUM_PIPE_HEIGHT ) - available_space + PIPE_GAP/2, false) -- Lower pipe
        table.insert(Pipes, { p1 = pipe1, p2 = pipe2 })
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
    love.graphics.print("last_set_distance: " .. Last_set_distance, 10, 20)

    Push:apply("end")
end
