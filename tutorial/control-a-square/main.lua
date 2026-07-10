function love.load()
    x = 0
    y = 0
end

function love.update(dt)
    if love.keyboard.isDown("right") then
        if x < 600 then
            x = x + 5
        end
    elseif love.keyboard.isDown("left") then
        if x > 0 then
            x = x - 5
        end
    elseif love.keyboard.isDown("up") then
        if y > 0 then
            y = y - 5
        end
    elseif love.keyboard.isDown("down") then
        if y < 600 then
            y = y + 5
        end
    end
end

function love.draw()
    love.graphics.rectangle("line", x, y, 200, 150)
end
