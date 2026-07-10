Bullet = Object:extend()

function Bullet:new(x, y)
    self.image = love.graphics.newImage("images/bullet.png")
    self.x = x
    self.y = y
    self.speed = 700
    self.width = self.image:getWidth()
    self.height = self.image:getHeight()
end

function Bullet:update(dt)
    self.y = self.y + self.speed * dt

    if self.y > love.graphics.getHeight() then
        love.load()
    end
end

function Bullet:draw()
    love.graphics.draw(self.image, self.x, self.y)
end

function Bullet:checkcollision(obj)
    local bullet_left = self.x
    local bullet_right = self.x + self.width
    local bullet_top = self.y
    local bullet_bottom = self.y + self.height

    if bullet_right > obj.x
        and bullet_left < obj.x + obj.width
        and bullet_bottom > obj.y
        and bullet_top < obj.y + obj.height
    then
        self.dead = true

        if obj.speed < 0 then
            obj.speed = obj.speed - 50
        elseif obj.speed > 0 then
            obj.speed = obj.speed + 50
        end
    end
end
