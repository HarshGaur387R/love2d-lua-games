Ball = Object:extend()

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
};

function Ball:new(x, y)
    self.x = x
    self.y = y
    self.radius = Ball_radius
    self.mode = "fill"
    self.y_velocity = 0
    self.x_velocity = (math.random(0, 1) == 1) and 1 or -1
end

function Ball:update(dt)
    -- turning balls direction to opposite way on collision with horizontal walls

    self.x = self.x + self.x_velocity
    self.y = self.y + self.y_velocity

    if self.y >= Window_height - Ball_radius then
        self.y_velocity = self.y_velocity * -1
    elseif self.y <= 0 then
        self.y_velocity = self.y_velocity * -1
    end

    if self.x < 0 then
        self.x = (Window_width / 2) - Ball_radius
        self.y = (Window_height / 2) - Ball_radius
        self.y_velocity = 0
        self.x_velocity = -1
        increasePlayer1Score()
    elseif self.x > (Window_width - Ball_radius) then
        self.x = (Window_width / 2) - Ball_radius
        self.y = (Window_height / 2) - Ball_radius
        self.y_velocity = 0
        self.x_velocity = 1
        increasePlayer2Score()
    end
end

-- This function will return the paddle that go hit.
function Ball:detectPaddleCollision(leftPaddle, rightPaddle)
    if (self.y + Ball_radius >= leftPaddle.y and self.y - Ball_radius <= leftPaddle.y + Paddle_height) and (self.x - Ball_radius <= Left_paddle_initial_point + Paddle_width) then
        return { isHit = true, paddle = "left" }
    elseif (self.y + Ball_radius >= rightPaddle.y and self.y - Ball_radius <= rightPaddle.y + Paddle_height) and (self.x + Ball_radius >= Right_paddle_initial_point) then
        return { isHit = true, paddle = "right" }
    else
        return { isHit = false, paddle = nil }
    end
end

function Ball:draw()
    love.graphics.circle(self.mode, self.x, self.y, self.radius)
end
