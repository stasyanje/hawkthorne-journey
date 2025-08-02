local FramePacer = {}
FramePacer.__index = FramePacer

function FramePacer.new(rect)
    local self = setmetatable({}, FramePacer)

    self.frame_times = table.repeating(0, 60)
    self.rect = rect
    self.shader = love.graphics.newShader('resources//shaders//frame_pacer.frag')

    if self.shader:hasUniform('size') then
        self.shader:send('size', {self.rect.w, self.rect.h})
    end

    return self
end

function table.repeating(value, times) 
    local table = {}
    for i = 1, times do 
        table[i] = value
    end
    return table
end

function FramePacer:update(dt)
    table.insert(self.frame_times, dt)
    table.remove(self.frame_times, 1)

    if self.shader:hasUniform('frame_times') then
        self.shader:send('frame_times', unpack(self.frame_times))
    end
end

function FramePacer:draw()
    love.graphics.push()
    love.graphics.setShader(self.shader)
    love.graphics.rectangle('fill', self.rect.x, self.rect.y, self.rect.w, self.rect.h)
    love.graphics.setShader()
    love.graphics.pop()
end

function FramePacer:setTargetFPS(fps)
    self.shader:send('target_frame_time', 1.0 / fps)
end

return FramePacer
