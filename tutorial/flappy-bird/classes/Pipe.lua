Pipe = Object:extend()

function Pipe:new(x, y, isFlipped)
    self.x = x
    self.y = y
    self.isFlipped = isFlipped
    self.image = love.graphics.newImage('images/pipe.png')
end

function Pipe:draw()
    
end