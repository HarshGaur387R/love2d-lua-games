function love.load()
    circle = {}
    circle.x = 100
    circle.y = 100
    circle.radius = 25
    circle.speed = 200
end

function love.update(dt)
    mouse_x, mouse_y = love.mouse.getPosition()
    angle = math.atan2(mouse_y - circle.y, mouse_x - circle.x)
end

function love.draw()
    love.graphics.circle("line", circle.x, circle.y, circle.radius)

    love.graphics.print("angle: " .. angle, 10, 10)

    love.graphics.line(circle.x, circle.y, mouse_x, circle.y)
    love.graphics.line(circle.x, circle.y, circle.x, mouse_y)
    love.graphics.line(circle.x, circle.y, mouse_x, mouse_y)
end
