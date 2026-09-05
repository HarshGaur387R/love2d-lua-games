function GenerateQuadsHearts(atlas,x, y)
    if atlas then
        return love.graphics.newQuad(x, y, 10, 10, atlas:getWidth(), atlas:getHeight())
    end
end
