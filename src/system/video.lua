local Video = {}
Video.__index = Video

function Video.new()
    local self = setmetatable({}, Video)

    self.prev_dt = 0
    self.total_time = 0
    self.frame = 0
    self.current_frame_delta = 0
    self.desired_frame_time = 1.0 / 60

    return self
end

function Video:update(dt)
    self.prev_dt = dt
    self.total_time = self.total_time + dt

    if self.current_frame_delta < self.desired_frame_time then
        self.current_frame_delta = self.current_frame_delta + dt
        return nil
    end

    local current_frame_delta = self.current_frame_delta
    self.current_frame_delta = 0
    self.frame = self.total_time / self.desired_frame_time

    return current_frame_delta
end

function Video:drawMetrics()
    love.graphics.print(math.floor(1 / math.max(self.prev_dt, self.desired_frame_time)))
end

function Video:setTargetFPS(fps)
    self.desired_frame_time = 1.0 / fps
end

return Video
