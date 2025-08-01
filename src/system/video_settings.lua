local video = require 'src/system/video'
local Slider = require 'ui/slider'
local window = require 'ui/window'

-- Global video settings
local VideoSettings = {
    video_system = nil,
    fps_slider = nil,
    target_fps = 60,
    initialized = false
}

function VideoSettings:initialize()
    if self.initialized then
        return
    end
    
    -- Create shared video system
    self.video_system = video.new()
    
    -- Create shared FPS slider
    self.fps_slider = Slider.new(window.width - 220, 20, 200, 20, 5, 120, self.target_fps, "Target FPS")
    
    -- Set initial target FPS
    self.video_system:setTargetFPS(self.target_fps)
    
    self.initialized = true
    print("VideoSettings initialized with target FPS:", self.target_fps)
end

function VideoSettings:update(dt)
    if not self.initialized then
        self:initialize()
    end
    
    -- Update slider
    self.fps_slider:update(dt)
    
    -- Check if FPS changed significantly (avoid micro-updates)
    local new_fps = math.floor(self.fps_slider:getValue() + 0.5) -- Round to nearest integer
    if new_fps ~= self.target_fps then
        self:setTargetFPS(new_fps)
    end
    
    -- Update video system
    self.video_system:update(dt)
end

function VideoSettings:setTargetFPS(fps)
    self.target_fps = fps
    if self.video_system then
        self.video_system:setTargetFPS(fps)
    end
    if self.fps_slider then
        self.fps_slider:setValue(fps)
    end
    print("Target FPS changed to:", fps)
end

function VideoSettings:getTargetFPS()
    return self.target_fps
end

function VideoSettings:draw()
    if self.video_system then
        self.video_system:drawMetrics()
    end
    if self.fps_slider then
        self.fps_slider:draw()
    end
end

function VideoSettings:getVideoSystem()
    if not self.initialized then
        self:initialize()
    end
    return self.video_system
end

function VideoSettings:getSlider()
    if not self.initialized then
        self:initialize()
    end
    return self.fps_slider
end

-- Export singleton instance
return VideoSettings