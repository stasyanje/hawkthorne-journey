local Gamestate = require 'vendor/gamestate'
local window = require 'ui/window'
local Circle = require 'system/drawables/circle'
local Rect = require 'system/drawables/rect'
local Collider = require 'system/collider'
local VideoSettings = require 'system/video_settings'

local intro = Gamestate.new()

function intro:init()
    self.frame = 0
    self.mouse_frame = 0

    self.pressLMB = nil
    self.floor = Rect:new(0, 0, 0, 0)
    self.moving_circle = Circle:new(-1, -1, 20)
    self.static_circle = Circle:new(100, 100, 20)
    self.player_circle = Circle:new(-1, -1, 10)
    self.collider = Collider:new(self.player_circle, self.floor)

    self.drawables = {self.floor, self.static_circle, self.moving_circle, self.player_circle}
end

function intro:enter()
    print('BINGO intro:enter ' .. love.graphics.getHeight())
end

function intro:leave()
    print('BINGO intro:leave')
end

function intro:update(dt)
    -- Update shared video settings
    VideoSettings:update(dt)
    
    local frame = VideoSettings:getVideoSystem().frame

    if frame == self.frame then
        return
    end

    self.frame = frame
    self:move()
    self.collider:update(dt)
end

function intro:draw()
    VideoSettings:draw()

    love.graphics.push()
    love.graphics.setBackgroundColor(0, 0, 0, 1)
    love.graphics.setColor(1, 1, 1, 1)

    -- love.graphics

    love.graphics.setFont(love.graphics.newFont(8))

    for _, drawable in ipairs(self.drawables) do
        drawable:draw()
    end
    
    -- Draw instructions
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.setFont(love.graphics.newFont(12))
    love.graphics.print("Press SPACE to enter the Room Game", 10, window.height - 20)

    love.graphics.pop()
end

function intro:move()
    -- moving circle
    self.moving_circle.y = 0.5 * window.height
    self.moving_circle.x = window.width * math.abs(math.sin(VideoSettings:getVideoSystem():totalTime()) * 0.5 + 0.5)

    -- collision scale
    local collision = self.collider:collideCircles(self.moving_circle, self.static_circle)
    self.moving_circle.r = 20 * (1.0 - 0.1 * collision)
    self.static_circle.r = 20 * (1.0 - 0.1 * collision)

    -- floor line
    self.floor.x = 0
    self.floor.y = window.height - 20
    self.floor.w = window.width
    self.floor.h = 3
end

-- Input Events

function love.mousepressed(x, y, button)
    if button == 1 then
        local click = Circle:new(x * window.scale, y * window.scale, 1)

        if intro.collider:collideCircles(intro.static_circle, click) > 0 then
            intro.pressLMB = click
        end
    end
end

function love.mousemoved(x, y)
    if intro.mouse_frame == intro.frame then
        return
    end
    intro.mouse_frame = intro.frame

    if intro.pressLMB ~= nil then
        intro.pressLMB.x = x * window.scale
        intro.pressLMB.y = y * window.scale
        intro.static_circle.x = intro.pressLMB.x
        intro.static_circle.y = intro.pressLMB.y
    end
end

function love.mousereleased(x, y, button)
    if button ~= 1 then
        return
    end
    intro.pressLMB = nil
end

function intro:keypressed(button, player)
    if button == 'START' then
        Gamestate.stack(require('core.scenes.pause_scene'))
        return true
    end

    if button == 'd' then
        intro.player_circle.x = intro.player_circle.x + 10
        VideoSettings:setTargetFPS(30)  -- Set to 30 FPS
        return true
    end

    if button == 'a' then
        intro.player_circle.x = intro.player_circle.x - 10
        VideoSettings:setTargetFPS(120) -- Set to 120 FPS
        return true
    end
    
    if button == 'space' then
        Gamestate.switch('scenes/room_scene')
        return true
    end

    intro.collider:keypressed(button)
end

return intro
