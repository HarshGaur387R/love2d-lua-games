-- Pre-defined vertical velocities for each segment (assuming base speed scale)
local SEGMENT_VELOCITIES = {
    -3.0, -- Segment 0 (Extreme Top): Sharp upward bounce
    -1.5, -- Segment 1 (Inner Top): Moderate upward bounce
    -0.5, -- Segment 2 (Outer Top Middle): Gentle upward bounce
    0.0,  -- Segment 3 (Center Top): Flat bounce
    0.0,  -- Segment 4 (Center Bottom): Flat bounce
    0.5,  -- Segment 5 (Outer Bottom Middle): Gentle downward bounce
    1.5,  -- Segment 6 (Inner Bottom): Moderate downward bounce
    3.0,  -- Segment 7 (Extreme Bottom): Sharp downward bounce
}

math.randomseed(os.time())
Window_width = love.graphics.getWidth()
Window_height = love.graphics.getHeight()
Paddle_top_limit = 67
Paddle_height = 100
Paddle_width = 20
Number_of_paddle_segments = 8
Ball_radius = 20
Left_paddle_initial_point = 0
Right_paddle_initial_point = Window_width - Paddle_width
Paddle_initial_y = (Window_height / 2) - (Paddle_height / 2)
DEBUG_VALUE = { index = 0, y_velocity = 0 }
Screen = "start" -- start | running | pause | victory |
Winner = nil
MaxScore = 3
SmallFont = love.graphics.newFont(20)
MediumFont = love.graphics.newFont(30)
LargeFont = love.graphics.newFont(40)

function increasePlayer1Score()
    topheader:increaseP1Score()
end

function increasePlayer2Score()
    topheader:increaseP2Score()
end

function love.load()
    Object = require "classic"
    require "classes.player"
    require "classes.ball"
    require "classes.topheader"

    topheader = TopHeader()

    player1 = Player(Left_paddle_initial_point, Paddle_initial_y, "w", "s")
    player2 = Player(Right_paddle_initial_point, Paddle_initial_y, "up", "down")
    ball = Ball((Window_width / 2) - Ball_radius, (Window_height / 2) - Ball_radius)
end

function love.update(dt)
    if Screen == "running" then
        player1:update(dt)
        player2:update(dt)
        ball:update(dt)

        -- Check is ball hit the paddle then check which paddle was hit
        local paddle = ball:detectPaddleCollision(player1, player2)

        -- Now check which segment of the paddle got hit and change the velocities according to it.
        if paddle.isHit and paddle.paddle then
            if paddle.paddle == "left" then
                local relativeHit = ball.y - player1.y
                local hitRatio = relativeHit / Paddle_height
                local segmentIndex = math.floor(hitRatio * Number_of_paddle_segments) + 1
                ball.x_velocity = 1
                local clampedIndex = math.max(1, math.min(Number_of_paddle_segments, segmentIndex)) -- index will be between 1 and 8
                ball.y_velocity = SEGMENT_VELOCITIES[clampedIndex]
                -- DEBUG_VALUE = { index = clampedIndex, y_velocity = SEGMENT_VELOCITIES[clampedIndex] }
            else
                local relativeHit = ball.y - player2.y
                local hitRatio = relativeHit / Paddle_height
                local segmentIndex = math.floor(hitRatio * Number_of_paddle_segments) + 1
                ball.x_velocity = -1
                local clampedIndex = math.max(1, math.min(Number_of_paddle_segments, segmentIndex)) -- index will be between 1 and 8
                ball.y_velocity = SEGMENT_VELOCITIES[clampedIndex]
                -- DEBUG_VALUE = { index = clampedIndex, y_velocity = SEGMENT_VELOCITIES[clampedIndex] }
            end
        end

        if topheader.p1_score == MaxScore then
            Winner = topheader.p1_name
            Screen = "victory"
        elseif topheader.p2_score == MaxScore then
            Winner = topheader.p2_name
            Screen = "victory"
        end
    end
end

function love.keypressed(key)
    if key == "space" and Screen == "start" then
        Screen = "running"
    elseif key == "space" and Screen == "running" then
        Screen = "pause"
    elseif key == "space" and Screen == "pause" then
        Screen = "running"
    elseif key == "space" and Screen == "victory" then
        ball:reset()
        player1:reset()
        player2:reset()
        topheader:reset()
        Screen = "running"
    end
end

function love.draw()
    topheader:draw()
    if Screen == "running" then
        player1:draw()
        player2:draw()
        ball:draw()
    elseif Screen == "start" then
        love.graphics.setFont(LargeFont)
        local Font = love.graphics.getFont()
        local startTitle = love.graphics.newText(Font)
        startTitle:add({ { 1, 1, 1 }, "Welcome to Pong" }, 0, 0)

        love.graphics.setFont(MediumFont)
        Font = love.graphics.getFont()
        local startMessage = love.graphics.newText(Font)
        startMessage:add({ { 1, 1, 1 }, "Press Space to start" }, 0, 0)
        love.graphics.draw(startTitle, (Window_width / 2) - (startTitle:getWidth() / 2), Window_height / 2)
        love.graphics.draw(startMessage, (Window_width / 2) - (startMessage:getWidth() / 2), (Window_height / 2) + 50)
    elseif Screen == "pause" then
        love.graphics.setFont(MediumFont)
        local Font = love.graphics.getFont()
        local pauseTitle = love.graphics.newText(Font)
        pauseTitle:add({ { 1, 1, 1 }, "Game Paused" }, 0, 0)

        love.graphics.setFont(SmallFont)
        Font = love.graphics.getFont()
        local pauseMessage = love.graphics.newText(Font)
        pauseMessage:add({ { 1, 1, 1 }, "Press space to start" }, 0, 0)

        love.graphics.draw(pauseTitle, (Window_width / 2) - (pauseTitle:getWidth() / 2), Window_height / 2)
        love.graphics.draw(pauseMessage, (Window_width / 2) - (pauseMessage:getWidth() / 2), (Window_height / 2) + 45)
    elseif Screen == "victory" then
        love.graphics.setFont(LargeFont)
        local Font = love.graphics.getFont()
        local victoryTitle = love.graphics.newText(Font)
        victoryTitle:add({ { 1, 1, 1 }, "Winner : " .. Winner }, 0, 0)

        love.graphics.setFont(MediumFont)
        Font = love.graphics.getFont()
        local victoryMessage = love.graphics.newText(Font)
        victoryMessage:add({ { 1, 1, 1 }, "Press Space to play again" }, 0, 0)

        love.graphics.draw(victoryTitle, (Window_width / 2) - (victoryTitle:getWidth() / 2), Window_height / 2)
        love.graphics.draw(victoryMessage, (Window_width / 2) - (victoryMessage:getWidth() / 2), (Window_height / 2) + 50)
    end

    --[[
    local debug_value = love.graphics.newText(font) ]]
    --[[  if DEBUG_VALUE.y_velocity and DEBUG_VALUE.index then
        debug_value:add(
            { { 1, 1, 1 }, "isHit: " ..
            "true, " .. "index:" .. DEBUG_VALUE.index .. ", y_velocity: " .. DEBUG_VALUE.y_velocity }, 0, 0)
    end ]]
    --[[  debug_value:add(
        { { 1, 1, 1 }, "index: ", DEBUG_VALUE.index }, 0, 0) ]] --
end
