local FramePacer = {}
FramePacer = {
    new = function(rect)
        local self = setmetatable({
            frame_times = {},
            max_samples = 60,  -- Keep 60 frame samples for display
            target_fps = 60,   -- Target 60 FPS (16.67ms per frame)
            rect = rect,
            shader = love.graphics.newShader('resources//shaders//frame_pacer.frag')
        }, {
            __index = FramePacer
        })

        self.shader:send('size', {self.rect.w, self.rect.h})
        self.shader:send('target_frame_time', 1.0 / self.target_fps)

        return self
    end,
    update = function(self, dt)
        -- Store the current frame time
        table.insert(self.frame_times, dt)
        
        -- Keep only the last max_samples frames
        if #self.frame_times > self.max_samples then
            table.remove(self.frame_times, 1)
        end
        
        -- Send frame times to shader if we have data
        if #self.frame_times > 0 then
            -- Pad array to max_samples with zeros if needed
            local padded_times = {}
            for i = 1, self.max_samples do
                padded_times[i] = self.frame_times[i] or 0
            end
            
            if self.shader:hasUniform('frame_times') then
                self.shader:send('frame_times', unpack(padded_times))
            end
            
            if self.shader:hasUniform('sample_count') then
                self.shader:send('sample_count', #self.frame_times)
            end
        end
    end,

    draw = function(self)
        love.graphics.push()
        love.graphics.setShader(self.shader)
        love.graphics.rectangle('fill', self.rect.x, self.rect.y, self.rect.w, self.rect.h)
        love.graphics.setShader()
        love.graphics.pop()
    end
}
return FramePacer
