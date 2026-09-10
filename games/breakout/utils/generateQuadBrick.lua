function GenerateQuadsBrick(atlas)
    if atlas then
        return love.graphics.newQuad(2, 0, 31, 15, atlas:getWidth(), atlas:getHeight())
    end
end