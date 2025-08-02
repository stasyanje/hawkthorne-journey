local Video = {}
Video.__index = Video

function Video.new()
    local self = setmetatable({}, Video)

    self.total_time = 0

    self.last_frame_times = {}
    self.current_frame_delta = 0

    self.target_frame_time = 1.0 / 60

    return self
end

function Video:update(dt)
    self.total_time = self.total_time + dt
    self.current_frame_delta = self.current_frame_delta + dt

    if self.current_frame_delta < self.target_frame_time then
        return nil
    end

    table.insert(self.last_frame_times, self.current_frame_delta)
    if #self.last_frame_times > 10 then
       table.remove(self.last_frame_times, 1)
    end

    local current_frame_delta = self.current_frame_delta
    self.current_frame_delta = 0
    return current_frame_delta
end

function Video:drawMetrics()
    local average = 0

    for i = 1, #self.last_frame_times do
        average = average + self.last_frame_times[i]
    end

    average = average / #self.last_frame_times

    love.graphics.print(average)
end

function Video:setTargetFPS(fps)
    self.target_frame_time = 1.0 / fps
end

return Video
