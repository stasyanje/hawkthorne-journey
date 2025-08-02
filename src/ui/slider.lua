local Slider = {}
Slider.__index = Slider

function Slider.new(rect, min_value, max_value, initial_value, label)
    local self = setmetatable({}, Slider)
    
    self.rect = rect
    self.min_value = min_value or 0
    self.max_value = max_value or 100
    self.value = initial_value or min_value
    self.label = label or ""
    
    self.dragging = false
    self.knob_width = 12
    self.track_height = 4
    
    return self
end

function Slider:update(dt)
    local mouse_x, mouse_y = love.mouse.getPosition()
    local mouse_pressed = love.mouse.isDown(1)
    
    -- Check if mouse is over the slider
    local over_slider = mouse_x >= self.rect.x
        and mouse_x <= self.rect.x + self.rect.w
        and mouse_y >= self.rect.y
        and mouse_y <= self.rect.y + self.rect.h

    if mouse_pressed and over_slider and not self.dragging then
        self.dragging = true
    elseif not mouse_pressed then
        self.dragging = false
    end
    
    if self.dragging then
        -- Calculate new value based on mouse position
        local relative_x = mouse_x - self.rect.x
        local normalized = math.max(0, math.min(1, relative_x / self.rect.w))
        self.value = self.min_value + normalized * (self.max_value - self.min_value)
    end
end

function Slider:draw()
    local track_y = self.rect.y + (self.rect.h - self.track_height) / 2
    
    -- Draw track background
    love.graphics.setColor(0.3, 0.3, 0.3, 0.8)
    love.graphics.rectangle("fill", self.rect.x, track_y, self.rect.w, self.track_height)
    
    -- Draw track fill
    local fill_width = ((self.value - self.min_value) / (self.max_value - self.min_value)) * self.rect.w
    love.graphics.setColor(0.2, 0.7, 0.9, 0.8)
    love.graphics.rectangle("fill", self.rect.x, track_y, fill_width, self.track_height)
    
    -- Draw knob
    local knob_x = self.rect.x + fill_width - self.knob_width / 2
    local knob_y = self.rect.y + (self.rect.h - self.knob_width) / 2
    
    if self.dragging then
        love.graphics.setColor(1, 1, 1, 1)
    else
        love.graphics.setColor(0.8, 0.8, 0.8, 1)
    end
    love.graphics.rectangle("fill", knob_x, knob_y, self.knob_width, self.knob_width)
    
    -- Draw label and value
    love.graphics.setColor(1, 1, 1, 1)
    local display_value = math.floor(self.value + 0.5) -- Round to nearest integer
    local text = string.format("%s: %d", self.label, display_value)
    love.graphics.print(text, self.rect.x, self.rect.y - 20)
    
    -- Reset color
    love.graphics.setColor(1, 1, 1, 1)
end

function Slider:getValue()
    return self.value
end

function Slider:setValue(value)
    self.value = math.max(self.min_value, math.min(self.max_value, value))
end

return Slider