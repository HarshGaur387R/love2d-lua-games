Bird = Object:extend()

local GRAVITY = 980
local JUMP_VELOCITY = -250

function Bird:new(x, y)
    self.x = x or BASE_WIDTH / 2
    self.y = y or BASE_HEIGHT / 2
    self.dy = 0
    self.image = love.graphics.newImage('images/bird.png')
    self.width = self.image:getWidth()
    self.height = self.image:getHeight()
end

function Bird:update(dt)
    self.dy = self.dy + GRAVITY * dt

    if love.keyboard.wasPressed('space') then
        self.dy = JUMP_VELOCITY
    end

    self.y = self.y + self.dy * dt
end

function Bird:draw()
    love.graphics.draw(self.image, self.x - self.width / 2, self.y - self.height / 2, 0)
end
