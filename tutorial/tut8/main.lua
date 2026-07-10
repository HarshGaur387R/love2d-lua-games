function love.load()
    myImage1 = love.graphics.newImage('sheep.png')
    width = myImage1:getWidth()
    height = myImage1:getHeight()
    love.graphics.setBackgroundColor(1,1,1)
end

function love.draw()
    love.graphics.setColor(255/255, 200/255, 40/255, 127/255)
    love.graphics.draw(myImage1, 100, 100, 0, 2, 2, width/2, height/2)
end
