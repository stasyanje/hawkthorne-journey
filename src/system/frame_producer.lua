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
    initialized = false
}

function FrameProducer:initialize()
    if self.initialized then
        return
    end
    self.initialized = true

    -- Create shared video system
    self.video_system = video.new()
    self.fps_slider = Slider.new(MakeRect(window.width - 220, 20, 200, 20), 5, 240, self.target_fps, "Target FPS")
    self.frame_pacer = FramePacer.new(MakeRect(0, 0, 80, 80))

    -- Set initial target FPS
    self:setTargetFPS(self.target_fps)
end

function FrameProducer:update(dt)
    self:initialize()

    self.fps_slider:update(dt)

    -- Check if FPS changed significantly (avoid micro-updates)
    local new_fps = math.floor(self.fps_slider:getValue() + 0.5) -- Round to nearest integer
    if new_fps ~= self.target_fps then
        self:setTargetFPS(new_fps)
    end

    local current_dt = self.video_system:update(dt)

    if current_dt then
        self.frame_pacer:update(current_dt) 
    end

    return current_dt
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
