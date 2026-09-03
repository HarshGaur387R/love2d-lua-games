function DisplayText(text, size, x, y)
    size = size or 'small'
    x = x or 0
    y = y or 0

    local font = Gfonts and Gfonts[size]

    if font then
        local previousFont = love.graphics.getFont()
        love.graphics.setFont(font)
        love.graphics.print(tostring(text), x, y)
        love.graphics.setFont(previousFont)
    else
        love.graphics.print(tostring(text), x, y)
    end
end
