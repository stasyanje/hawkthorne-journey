local video = require 'src/system/video'
local Slider = require 'ui/slider'
local FramePacer = require 'ui/frame_pacer'
local window = require 'ui/window'
local MakeRect = require 'src/system/drawables/make_rect'

-- Global video settings
local FrameProducer = {
    video_system = nil,
    fps_slider = nil,
    frame_pacer = nil,
    target_fps = 60,
    current_frame = 0,
    initialized = false
}

function FrameProducer:initialize()
    if self.initialized then
        return
    end

    -- Create shared video system
    self.video_system = video.new()

    -- Create shared FPS slider
    self.fps_slider = Slider.new(MakeRect(window.width - 220, 20, 200, 20), 1, 120, self.target_fps, "Target FPS")
    self.frame_pacer = FramePacer.new(MakeRect(0, 0, 80, 80))

    -- Set initial target FPS
    self.video_system:setTargetFPS(self.target_fps)

    self.initialized = true
end

function FrameProducer:update(dt)
    self:initialize()

    -- dt = math.min(0.1, dt)

    -- Update slider
    self.fps_slider:update(dt)

    -- Check if FPS changed significantly (avoid micro-updates)
    local new_fps = math.floor(self.fps_slider:getValue() + 0.5) -- Round to nearest integer
    if new_fps ~= self.target_fps then
        self:setTargetFPS(new_fps)
    end

    local delta = self.video_system:update(dt)

    self.current_frame = self.current_frame + 1
    self.frame_pacer:update(dt)

    return delta
end

function FrameProducer:draw()
    self:initialize()

    self.video_system:drawMetrics()
    self.fps_slider:draw()
    self.frame_pacer:draw()
end

function FrameProducer:setTargetFPS(fps)
    self.target_fps = fps

    self.video_system:setTargetFPS(fps)
    self.fps_slider:setValue(fps)
    self.frame_pacer:setTargetFPS(fps)
end

return FrameProducer
