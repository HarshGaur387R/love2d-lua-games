function love.load()
    Object = require "classic"
    require "player"
    require "enemy"
    require "bullet"

    player = Player()
    enemy = Enemy()
    listOfBullets = {}
end

function love.keypressed(key)
    player:keypressed(key)
end

function love.update(dt)
    player:update(dt)
    enemy:update(dt)

    for i, bullet in ipairs(listOfBullets) do
        bullet:update(dt)
        bullet:checkcollision(enemy)

        if bullet.dead then
            table.remove(listOfBullets, i)
        end
    end
end

function love.draw()
    player:draw()
    enemy:draw()

    for _, bullet in ipairs(listOfBullets) do
        bullet:draw()
    end
end
