require "states.BaseState"
require "classes.Arrow"
require "classes.MarginBox"

PlayState = BaseState:extend()

function PlayState:enter()
    UpArrow = Arrow(10, VIRTUAL_HEIGHT - ARROW_HEIGHT, GetArrowQuads("up"), false, "up", function() end)
    LeftArrow = Arrow(90, VIRTUAL_HEIGHT - ARROW_HEIGHT, GetArrowQuads("left"), false, "left", function() end)
    DownArrow = Arrow(180, VIRTUAL_HEIGHT - ARROW_HEIGHT, GetArrowQuads("down"), false, "down", function() end)
    RightArrow = Arrow(270, VIRTUAL_HEIGHT - ARROW_HEIGHT, GetArrowQuads("right"), false, "right", function() end)

    ArrowsButtonBox = MarginBox("bottom-horizontal",
        { leftPad = 10, rightPad = 10, bottomPad = 0, topPad = 0 },
        20,
        { UpArrow, LeftArrow, DownArrow, RightArrow }
    )
end

function PlayState:update(dt)
    ArrowsButtonBox:update(dt)
end

function PlayState:render()
    ArrowsButtonBox:render()
end
