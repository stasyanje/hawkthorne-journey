Rect = {}
Rect.__index = Rect

function Rect:new(x, y, w, h)
    return setmetatable({
        x = x,
        y = y,
        w = w,
        h = h
    }, Rect)
end

function Rect:draw()
    love.graphics.rectangle('fill', self.x, self.y, self.w, self.h)
end

return Rect
