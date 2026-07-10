function love.load()
	x = 100
end

function love.update(dt)
	if x < 600 then
		x = x + 5
	end
end

function love.draw()
	love.graphics.rectangle("line", x, 50, 200, 150)
end
