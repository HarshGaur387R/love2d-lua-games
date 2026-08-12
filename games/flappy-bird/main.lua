BASE_WIDTH = 512
BASE_HEIGHT = 288

function love.load()
    Object = require("classic")
    require "classes.Bird"
    require "classes.Pipe"
    Push = require "push"
    love.graphics.setDefaultFilter("linear", "linear")
    math.randomseed(os.time())

    -- initialize our nice-looking retro text fonts
    smallFont = love.graphics.newFont('fonts/font.ttf', 8)
    mediumFont = love.graphics.newFont('fonts/flappy.ttf', 14)
    largeFont = love.graphics.newFont('fonts/flappy.ttf', 20)
    flappyFont = love.graphics.newFont('fonts/flappy.ttf', 28)
    hugeFont = love.graphics.newFont('fonts/flappy.ttf', 56)

    love.keyboard.keysPressed = {}
    love.mouse.buttonsPressed = {}

    Score = 0
    STATES = {
        'titleScreen', -- done
        'play',        -- done
        'pause',       -- remain
        'Score'        -- remain
    }

    CurrentState = 'titleScreen'

    Pipes = {} -- This table contains set of pipes eg. {{upPipe1, downPipe1}, {upPipe2, downPipe2}}
    PIPES_SET_GAP = 100
    PIPE_GAP = 80
    Scrolling = true

    WINDOW_WIDTH = love.graphics.getWidth()
    WINDOW_HEIGHT = love.graphics.getHeight()

    Background_image = love.graphics.newImage('images/background.png')
    BackgroundScroll = 0
    BACKGROUND_LOOP_POINT = 413
    BACKGROUND_SCROLL_SPEED = 30

    Ground_image = love.graphics.newImage('images/ground.png')
    Ground_Scroll = 0
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

    if key == "return" then
        if CurrentState == "titleScreen" then
            Scrolling = true
            CurrentState = "play"
        elseif CurrentState == "play" then
            Scrolling = false
            CurrentState = "pause"
        elseif CurrentState == "pause" then
            Scrolling = true
            CurrentState = "play"
        elseif CurrentState == "score" then
            Scrolling = true
            Score = 0
            Pipes = {}
            Flappy_bird = Bird(BASE_WIDTH / 2, BASE_HEIGHT / 2)
            local pipe1 = Pipe(BASE_WIDTH, 0 + MINIMUM_PIPE_HEIGHT, true)            -- Upper pipe
            local pipe2 = Pipe(BASE_WIDTH, BASE_HEIGHT - MINIMUM_PIPE_HEIGHT, false) --Lower pipe
            table.insert(Pipes, { p1 = pipe1, p2 = pipe2 })
            CurrentState = "play"
        end
    end
end

function love.mousepressed(x, y, button)
    love.mouse.buttonsPressed[button] = true
end

love.mouse.wasPressed = function(key)
    if love.mouse.buttonsPressed[key] then
        return true
    else
        return false
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
    if Flappy_bird.y + Flappy_bird.image:getHeight() > BASE_HEIGHT or Flappy_bird.y < 0 then
        CurrentState = 'score'
        Scrolling = false
    end

    if BackgroundScroll >= BACKGROUND_LOOP_POINT then
        BackgroundScroll = 0
    end

    if Ground_Scroll >= BASE_WIDTH then
        Ground_Scroll = 0
    end

    if Scrolling == true then
        BackgroundScroll = BackgroundScroll + BACKGROUND_SCROLL_SPEED * dt
        Ground_Scroll = Ground_Scroll + GROUND_SCROLL_SPEED * dt
    end

    if CurrentState == 'play' then
        -- If the distance is equals to the given gap then
        Last_set_distance = BASE_WIDTH - (Pipes[#Pipes].p1.x + Pipes[#Pipes].p1.image:getWidth())

        if math.floor(Last_set_distance) == PIPES_SET_GAP then
            local upperY = math.random(MINIMUM_PIPE_HEIGHT, BASE_HEIGHT - MINIMUM_PIPE_HEIGHT)
            local pipe1 = Pipe(BASE_WIDTH, upperY - PIPE_GAP / 2, true) -- Upper pipe

            -- local available_space = (BASE_HEIGHT - MINIMUM_PIPE_HEIGHT) - upperY
            local pipe2 = Pipe(BASE_WIDTH, upperY + PIPE_GAP / 2, false) -- Lower pipe
            table.insert(Pipes, { p1 = pipe1, p2 = pipe2 })
        end

        for index, set_of_pipe in ipairs(Pipes) do
            set_of_pipe.p1:update(dt)
            set_of_pipe.p2:update(dt)

            if set_of_pipe.p1.x + set_of_pipe.p1.image:getWidth() - 20 < Flappy_bird.x - Flappy_bird.image:getWidth() then
                if set_of_pipe.p1.isFlagged == false then
                    Score = Score + 1
                    set_of_pipe.p1.isFlagged = true
                end
            end

            local upperPipe = set_of_pipe.p1
            local lowerPipe = set_of_pipe.p2

            if Flappy_bird.x + Flappy_bird.image:getWidth() > upperPipe.x + 20 and Flappy_bird.x < upperPipe.x + upperPipe.image:getWidth() and Flappy_bird.y < upperPipe.y + 11 then
                CurrentState = 'score'
                Scrolling = false
            end

            if Flappy_bird.x + Flappy_bird.image:getWidth() > lowerPipe.x + 20 and Flappy_bird.x < lowerPipe.x + lowerPipe.image:getWidth() and Flappy_bird.y > lowerPipe.y - 11 then
                CurrentState = 'score'
                Scrolling = false
            end

            if set_of_pipe.p1.x + set_of_pipe.p1.image:getWidth() < 0 then
                table.remove(Pipes, index)
            end
        end
        Flappy_bird:update(dt)
    end

    -- Empty keysPressed table at every update.
    love.keyboard.keysPressed = {}
    love.mouse.buttonsPressed = {}
end

function love.draw()
    Push:apply("start")
    love.graphics.clear(1, 1, 1, 1)

    -- Background image
    love.graphics.draw(Background_image, -BackgroundScroll, 0)
    love.graphics.draw(Ground_image, -Ground_Scroll, BASE_HEIGHT - Ground_image:getHeight())

    -- love.graphics.print("last_set_distance: " .. Last_set_distance, 10, 20)

    if CurrentState == 'titleScreen' then
        love.graphics.setFont(flappyFont)
        love.graphics.printf('Flappy Bird', 0, 64, BASE_WIDTH, 'center')

        love.graphics.setFont(mediumFont)
        love.graphics.printf('Press Enter to play', 0, 100, BASE_WIDTH, 'center')
    end

    -- if CurrentState == 'play' then
    -- end
    Flappy_bird:draw()

    for _, pipeSet in ipairs(Pipes) do
        pipeSet.p1:draw()
        pipeSet.p2:draw()
    end
    -- Show number of pipes on screen
    -- love.graphics.print("Pipes: " .. #Pipes, 10, 10)
    if CurrentState ~= 'score' and CurrentState ~= 'titleScreen' then
        love.graphics.setFont(largeFont)
        love.graphics.print(Score, BASE_WIDTH / 2, 20)
    end

    if CurrentState == 'score' then
        love.graphics.setFont(flappyFont)
        love.graphics.printf('Game over', 0, 64, BASE_WIDTH, 'center')

        love.graphics.setFont(largeFont)
        love.graphics.printf('Score: ' .. Score, 0, 100, BASE_WIDTH, 'center')

        love.graphics.setFont(mediumFont)
        love.graphics.printf('Press Enter to play', 0, 156, BASE_WIDTH, 'center')
    end

    Push:apply("end")
end
