function love.load()
    listOfRects = {}
end

function createRect()
    rect = {
        x = 100,
        y = 100,
        width = 70,
        height = 90,
        speed = 100,
    }

    table.insert(listOfRects, rect)
end

function love.keypressed(key)
    if key == "space" then
        createRect()
    end
end

function love.update(dt)
    for _, rect in ipairs(listOfRects) do
        rect.x = rect.x + rect.speed * dt
    end
end

function love.draw()
    for _, rect in ipairs(listOfRects) do
        love.graphics.rectangle("line", rect.x, rect.y, rect.width, rect.height)
    end
end
