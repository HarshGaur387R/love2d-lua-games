Pipe = Object:extend()

function Pipe:new(x, y, isFlipped)
    self.x = x
    self.y = y
    self.isFlipped = isFlipped
    self.image = love.graphics.newImage('images/pipe.png')
    self.isFlagged = false -- Set to true when bird.x > pipe.x + pipe.image:getWidth()
end

function Pipe:draw()

    if self.isFlipped then
        love.graphics.draw(
            self.image,
            self.x,
            self.y,
            math.pi,
            -1,
            1
        )
    else
        love.graphics.draw(self.image, self.x, self.y, 0)
    end
end

function Pipe:update(dt)
    self.x = self.x - GROUND_SCROLL_SPEED * dt
end
