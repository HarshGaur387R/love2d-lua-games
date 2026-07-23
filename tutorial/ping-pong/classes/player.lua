-- The name of this class should be paddle.

Player = Object:extend()

function Player:new(x, y, upKey, downKey)
    self.width = Paddle_width
    self.height = Paddle_height
    self.x = x
    self.y = y
    self.speed = 500
    self.upKey = upKey
    self.downKey = downKey
end

function Player:draw()
    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
end

function Player:update(dt)
    if love.keyboard.isDown(self.downKey) then
        self.y = self.y + self.speed * dt
    elseif love.keyboard.isDown(self.upKey) then
        self.y = self.y - self.speed * dt
    end

    if self.y > Window_height - self.height then
        self.y = Window_height - self.height
    elseif self.y < Paddle_top_limit then
        self.y = Paddle_top_limit
    end
end
