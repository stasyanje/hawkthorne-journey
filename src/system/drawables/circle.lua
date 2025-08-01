Circle = {}
Circle.__index = Circle

function Circle:new(x, y, r)
    return setmetatable({
        x = x,
        y = y,
        r = r,
        a = 0
    }, Circle)
end

function Circle:draw()
    love.graphics.circle('fill', self.x, self.y, self.r)
end

return Circle
