function love.load()
    frames = {}
    local maxFrames = 5
    local frame_width = 117
    local frame_height = 233
    image = love.graphics.newImage("images/jump_3.png")

    for j = 0, 1, 1 do
        for i = 0, 2, 1 do
            table.insert(frames,
                love.graphics.newQuad(
                    1 + i * (frame_width + 2),   -- Starting x of quad
                    1 + j * (frame_height + 2),  -- Starting y of quad
                    frame_width,       -- width of quad
                    frame_height,      -- height of quad
                    image:getWidth(),  -- image width
                    image:getHeight()) -- image height
            )

            if #frames == maxFrames then
                break
            end
        end
    end

    currentFrame = 1
end

function love.update(dt)
    currentFrame = currentFrame + 10 * dt

    if currentFrame >= 6 then
        currentFrame = 1
    end
end

function love.draw()
    love.graphics.draw(image, frames[math.floor(currentFrame)], 100, 100)
end
