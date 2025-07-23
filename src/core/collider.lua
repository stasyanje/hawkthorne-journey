local window = require "window"
local Collider = {}
Collider.__index = Collider

local singleton = {}

function Collider:new(playerCircle, floor)
    singleton.player_circle = playerCircle
    singleton.floor = floor
    return setmetatable(singleton, Collider)
end

local function distance(x1, y1, x2, y2)
    return math.sqrt((x2 - x1) ^ 2 + (y2 - y1) ^ 2)
end

function Collider:collideCircles(circle1, circle2)
    local distance = distance(circle1.x, circle1.y, circle2.x, circle2.y)
    local intersection = math.max(0, circle1.r + circle2.r - distance)

    if intersection > 0 then
        print("collision: ", circle1.x, circle2.x)
        return 1
    end

    return 0
end

function Collider:update(dt)
    -- circle.a
    local circle = self.player_circle
    local maxY = self.floor.y - circle.r

    if circle.x == -1 then
        circle.x = window.width * 0.5
        circle.y = maxY
    end

    -- apply gravity
    if circle.y <= maxY then
        local g = 0.01
        circle.a = circle.a - g
    end

    circle.y = circle.y - circle.a

    if circle.y >= maxY then
        circle.y = maxY
        circle.a = 0
    end
end

function Collider:keypressed(button)
    if button == 'space' and self.player_circle.a == 0 then
        self.player_circle.a = self.player_circle.a + 1
    end
end

return Collider
