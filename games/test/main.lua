function love.load()
    circle = { x = 100, y = 100 }
    bullets = {}
    bulletsCount = 0
end

function love.update(dt)
    for i, v in ipairs(bullets) do
        if v then
            v.x = v.x + 400 * dt
            print(v.x)
        end
    end

    for i, v in ipairs(bullets) do
        if v and v.x > love.graphics:getWidth() then
            table.remove(bullets, i)
        end
    end

    bulletsCount = #bullets
end

function love.draw()
    love.graphics.circle("fill", circle.x, circle.y, 50)

    for i, v in ipairs(bullets) do
        love.graphics.circle("fill", v.x, v.y, 10)
    end

    love.graphics.print(bulletsCount, 100, 200)
end

function love.keypressed(key)
    if key == "space" then
        shoot()
    end
end

function shoot()
    table.insert(bullets, { x = circle.x, y = circle.y })
end
