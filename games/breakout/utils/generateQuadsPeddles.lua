function GenerateQuadsPaddles(atlas)
    if atlas then
        Peddles = {}
        local PaddlesCoordinates = { { x1 = 0, x2 = 32 }, { x1 = 32, x2 = 96 }, { x1 = 96, x2 = 192 }, { x1 = 0, x2 = 128 } }
        local PaddleStarting_Y = 64
        local PaddlesHeight = 15

        for _ = 1, 4, 1 do
            for i = 1, 4, 1 do
                if i == 4 then
                    PaddleStarting_Y = PaddleStarting_Y + PaddlesHeight + 1
                end

                local p = love.graphics.newQuad(PaddlesCoordinates[i].x1, PaddleStarting_Y,
                    PaddlesCoordinates[i].x2 - PaddlesCoordinates[i].x1, PaddlesHeight, atlas:getWidth(),
                    atlas:getHeight())

                table.insert(Peddles, p)
            end
            PaddleStarting_Y = PaddleStarting_Y + PaddlesHeight + 1
        end

        return Peddles
    end
end
