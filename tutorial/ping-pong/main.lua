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
DEBUG_VALUE = {}

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

    player1 = Player(Left_paddle_initial_point, Paddle_top_limit, "w", "s")
    player2 = Player(Right_paddle_initial_point, Paddle_top_limit, "up", "down")
    ball = Ball((Window_width / 2) - Ball_radius, (Window_height / 2) - Ball_radius)
end

function love.update(dt)
    player1:update(dt)
    player2:update(dt)
    ball:update(dt)

    -- Check is ball hit the paddle then check which paddle was hit
    local paddle = ball:detectPaddleCollision(player1, player2)

    -- Now check which segment of the paddle got hit

    -- Change the velocity of the ball according to the segment list.

end

function love.draw()
    topheader:draw()
    player1:draw()
    player2:draw()
    ball:draw()

    --[[    local font = love.graphics.getFont()
    local debug_value = love.graphics.newText(font) ]]

    --[[ if DEBUG_VALUE.isHit then
        debug_value:add({ { 1, 1, 1 }, "isHit: " .. DEBUG_VALUE.isHit .. ", paddle: " .. DEBUG_VALUE.paddle }, 0, 0)
        love.graphics.draw(debug_value, Window_width/2, Window_height/2)
    end ]]
end
