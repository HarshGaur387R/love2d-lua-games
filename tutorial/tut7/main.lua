local rec, cir

function love.load()
    Object = require "classic"
    local Rectangle = require "rectangle"
    local Circle = require "circle"

    rec = Rectangle(100, 100, 200, 50)
    cir = Circle(350, 80, 50)
end

function love.update(dt)
    rec:update(dt)
    cir:update(dt)
end

function love.draw()
    rec:draw()
    cir:draw()
end