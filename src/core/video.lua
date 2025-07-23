local Video = {}
Video.__index = Video

function Video:new()
    return setmetatable({
        prev_dt = 0,
        total_time = 0,
        frame = 0,
        current_frame_delta = 0,
        desired_frame_time = 1000.0 / 60 / 1000
    }, Video)
end

function Video:fps()
    return 1 / math.max(self.prev_dt, self.desired_frame_time)
end

function Video:round(x)
    return x >= 0 and math.floor(x + 0.5) or math.ceil(x - 0.5)
end

function Video:setDesiredFPS(fps)
    self.desired_frame_time = 1000.0 / fps / 1000
end

function Video:currentFrame(dt)
    self.prev_dt = dt
    self.total_time = self.total_time + dt

    if self.current_frame_delta < self.desired_frame_time then
        self.current_frame_delta = self.current_frame_delta + dt
        return self.frame
    end

    print(self.current_frame_delta)
    self.current_frame_delta = 0
    self.frame = self.total_time / self.desired_frame_time

    return self.frame
end

return Video
