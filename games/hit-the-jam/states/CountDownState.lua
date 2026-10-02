require "states.BaseState"
require "classes.Arrow"
require "classes.MarginBox"

CountDownState = BaseState:extend()

function CountDownState:enter()
    self.IsCounting = true
    self.counts = 3
    self.countdownElapsed = 0

    local Y_Constant = 30

    UpArrow = Arrow(10, VIRTUAL_HEIGHT - ARROW_HEIGHT + Y_Constant, GetArrowQuads("up"), false, "up", function() end)
    LeftArrow = Arrow(90, VIRTUAL_HEIGHT - ARROW_HEIGHT + Y_Constant, GetArrowQuads("left"), false, "left",
        function() end)
    DownArrow = Arrow(180, VIRTUAL_HEIGHT - ARROW_HEIGHT + Y_Constant, GetArrowQuads("down"), false, "down",
        function() end)
    RightArrow = Arrow(270, VIRTUAL_HEIGHT - ARROW_HEIGHT + Y_Constant, GetArrowQuads("right"), false, "right",
        function() end)

    ArrowsButtonBox = MarginBox("bottom-horizontal",
        { leftPad = 10, rightPad = 10, bottomPad = 0, topPad = 0 },
        20,
        { UpArrow, LeftArrow, DownArrow, RightArrow }
    )
end

function CountDownState:update(dt)
    if self.IsCounting then
        self.countdownElapsed = self.countdownElapsed + dt

        while self.countdownElapsed >= 1 do
            self.countdownElapsed = self.countdownElapsed - 1
            self.counts = self.counts - 1

            if self.counts == 0 then
                self.IsCounting = false
                GStateMachine:change('play')
                return
            end
        end
    end
    -- ArrowsButtonBox:update(dt)
end

function CountDownState:render()
    love.graphics.printf(tostring(self.counts), 0, VIRTUAL_HEIGHT / 2 - 16, VIRTUAL_WIDTH, "center")
    ArrowsButtonBox:render()
end
