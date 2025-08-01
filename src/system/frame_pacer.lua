local FramePacer = {}
FramePacer = {
    new = function(rect)
        local self = setmetatable({
            frame_pace_history = {},
            frame_pace_current = 0,
            frame_pace_count = 0,
            frame_pace_hz = 1,
            rect = rect,
            shader = love.graphics.newShader('resources//shaders//frame_pacer.frag')
        }, {
            __index = FramePacer
        })

        self.shader:send('size', self.rect.w * 2.0, self.rect.h * 2.0)

        if self.shader:hasUniform('intervals') then
            self.shader:send('intervals', -1, 1)
        end

        return self
    end,
    update = function(self, current_frame_delta)
        self.frame_pace_count = self.frame_pace_count + 1
        self.frame_pace_current = self.frame_pace_current + current_frame_delta

        if self.frame_pace_current > self.frame_pace_hz then
            table.insert(self.frame_pace_history, #self.frame_pace_history, self.frame_pace_current)

            if table.getn(self.frame_pace_history) > 10 then
                table.remove(self.frame_pace_history, 1)
            end

            self.frame_pace_current = 0
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
