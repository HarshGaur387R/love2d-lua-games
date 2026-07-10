function love.load()
    fruits = { "banana", "apple", "mango", "grapes" }
end

function love.draw()
    for index, value in ipairs(fruits) do
        love.graphics.print(value, 100, 100 + 50 * index)
    end
end