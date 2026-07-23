TopHeader = Object:extend()
TOP_HEADER = {
    x1 = 0,
    y1 = 60,
    x2 = Window_width,
    y2 = 60
}

function TopHeader:new()
    self.x1 = TOP_HEADER.x1
    self.x2 = TOP_HEADER.x2
    self.y1 = TOP_HEADER.y1
    self.y2 = TOP_HEADER.y2
    self.p1_name = 'Player 1'
    self.p2_name = 'Player 2'
    self.p1_score = 0
    self.p2_score = 0
    self.font = love.graphics.newFont(30)
end

function TopHeader:setPlayer1Name(name)
    self.p1_name = name
end

function TopHeader:setPlayer2Name(name)
    self.p2_name = name
end

function TopHeader:increaseP1Score()
    self.p1_score = self.p1_score + 1
end

function TopHeader:increaseP2Score()
    self.p2_score = self.p2_score + 1
end

function TopHeader:draw()
    -- Using for-loop to make lines thick

    -- header and game screen separator
    for i = 1, 5, 1 do
        love.graphics.line(self.x1, self.y1 + i, self.x2, self.y2 + i)
    end

    -- Score box separator
    for i = 1, 5, 1 do
        love.graphics.line((Window_width / 2) + i, 0, (Window_width / 2) + i, 60)
    end

    love.graphics.setFont(self.font)
    
    -- Show names and scores on screen
    local font = love.graphics.getFont()
    player1text = love.graphics.newText(font)
    player2text = love.graphics.newText(font)

    player1text:add({ { 1, 1, 1 }, self.p1_name }, 0, 0)
    player2text:add({ { 1, 1, 1 }, self.p2_name }, 0, 0)

    player1Score = love.graphics.newText(font)
    player2Score = love.graphics.newText(font)

    player1Score:add({ { 1, 1, 1 }, self.p1_score }, 0, 0)
    player2Score:add({ { 1, 1, 1 }, self.p2_score }, 0, 0)

    love.graphics.draw(player1text, 10, 10)
    love.graphics.draw(player2text, Window_width - (player2text:getWidth() + 10), 10)

    love.graphics.draw(player1Score, (Window_width / 2) - 40, 10)
    love.graphics.draw(player2Score, (Window_width / 2) + 28, 10)
end
