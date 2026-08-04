function love.load()
    --Load the image
    image = love.graphics.newImage("images/tileset.png")

    --We need the full image width and height for creating the quads
    local image_width = image:getWidth()
    local image_height = image:getHeight()

    --The width and height of each tile is 32, 32
    --So we could do:
    width = 32
    height = 32
    --But let's say we don't know the width and height of a tile
    --We can also use the number of rows and columns in the tileset
    --Our tileset has 2 rows and 3 columns
    --But we need to subtract 2 to make up for the empty pixels we included to prevent bleeding
    width = (image_width / 3) - 2
    height = (image_height / 2) - 2

    --Create the quads
    quads = {}

    for i = 0, 1 do
        for j = 0, 2 do
            --The only reason this code is split up in multiple lines
            --is so that it fits the page
            table.insert(quads,
                love.graphics.newQuad(
                    1 + j * (width + 2),
                    1 + i * (height + 2),
                    width, height,
                    image_width, image_height))
        end
    end

    tilemap = {
        { 1, 6, 6, 2, 1, 6, 6, 2 },
        { 3, 0, 0, 4, 5, 0, 0, 3 },
        { 3, 0, 0, 0, 0, 0, 0, 3 },
        { 4, 2, 0, 0, 0, 0, 1, 5 },
        { 1, 5, 0, 0, 0, 0, 4, 2 },
        { 3, 0, 0, 0, 0, 0, 0, 3 },
        { 3, 0, 0, 1, 2, 0, 0, 3 },
        { 4, 6, 6, 5, 4, 6, 6, 5 }
    }
end

function love.draw()
    for i, row in ipairs(tilemap) do
        for j, tile in ipairs(row) do
            if tile ~= 0 then
                love.graphics.draw(image, quads[tile], j * width, i * height)
            end
        end
    end
end
