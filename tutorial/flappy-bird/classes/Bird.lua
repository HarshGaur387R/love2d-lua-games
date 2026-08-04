Bird = Object:extend()

function Bird:new(x, y)
    self.x = x or BASE_WIDTH / 2
    self.y = y or BASE_HEIGHT / 2
    self.image = love.graphics.newImage('images/bird.png')
    self.width = self.image:getWidth()
    self.height = self.image:getHeight()
end

function Bird:draw()
    love.graphics.draw(self.image, self.x - self.width / 2, self.y - self.height / 2, 0)
end
