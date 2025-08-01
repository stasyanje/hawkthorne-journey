local FramePacer = require "/system/frame_pacer"

--- @module src.video
local video = {}

-- class table
local Video = {}

function video.new()
    local Rect = require 'system/drawables/rect'
    local self = setmetatable({
        prev_dt = 0,
        total_time = 0,
        frame = 0,
        current_frame_delta = 0,
        target_fps = 60,
        desired_frame_time = 1.0 / 60,
        frame_pacer = FramePacer.new({x = 0, y = 0, w = 80, h = 80})
    }, {
        __index = Video
    })

    return self
end

function Video:totalTime()
    return self.total_time
end

function Video:round(x)
    return x >= 0 and math.floor(x + 0.5) or math.ceil(x - 0.5)
end

function Video:update(dt)
    self.prev_dt = dt
    self.total_time = self.total_time + dt

    if self.current_frame_delta < self.desired_frame_time then
        self.current_frame_delta = self.current_frame_delta + dt
        return self.frame
    end

    self.frame_pacer:update(self.current_frame_delta)

    self.current_frame_delta = 0
    self.frame = self.total_time / self.desired_frame_time

    return self.frame
end

function Video:drawMetrics()
    self.frame_pacer:draw()
    love.graphics.print(math.floor(1 / math.max(self.prev_dt, self.desired_frame_time)))
end

function Video:setTargetFPS(fps)
    self.target_fps = fps
    self.desired_frame_time = 1.0 / fps
    if self.frame_pacer then
        self.frame_pacer:setTargetFPS(fps)
    end
end

function Video:getTargetFPS()
    return self.target_fps
end

return video
