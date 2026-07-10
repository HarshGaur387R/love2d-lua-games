function love.load()
    circle = {}
    circle.x = 100
    circle.y = 100
    circle.radius = 25
    circle.speed = 200
end

function love.draw()
    love.graphics.circle("line", circle.x, circle.y, circle.radius)
end