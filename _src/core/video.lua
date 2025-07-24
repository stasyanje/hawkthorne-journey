--- @module src.video
local video = {}

-- class table
local Video = {}

function video.new()
    local self = setmetatable({
        prev_dt = 0,
        total_time = 0,
        frame = 0,
        current_frame_delta = 0,
        desired_frame_time = 1000.0 / 60 / 1000
    }, { __index = Video })

    return self
end

function Video:fps()
    return 1 / math.max(self.prev_dt, self.desired_frame_time)
end

function Video:round(x)
    return x >= 0 and math.floor(x + 0.5) or math.ceil(x - 0.5)
end

function Video:currentFrame(dt)
    self.prev_dt = dt
    self.total_time = self.total_time + dt

    if self.current_frame_delta < self.desired_frame_time then
        self.current_frame_delta = self.current_frame_delta + dt
        return self.frame
    end

    self.current_frame_delta = 0
    self.frame = self.total_time / self.desired_frame_time

    return self.frame
end

function Video:drawMetrics()
    local width = 170
    local height = 100

    love.graphics.print(1 / math.max(self.prev_dt, self.desired_frame_time))

    love.graphics.setColor(1, 0, 0, 0.3)
    love.graphics.rectangle('fill', 0, 0, width, height)
end

return video
