function love.load()
   image = love.graphics.newImage("jump.png")
end

function love.update(dt)
    currentFrame = currentFrame + 10 * dt

    if currentFrame >= 6 then
        currentFrame = 1
    end
end

function love.draw()
    love.graphics.draw(frames[math.floor(currentFrame)])
end