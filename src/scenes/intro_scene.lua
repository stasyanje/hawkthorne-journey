local Gamestate = require 'vendor/gamestate'
local window = require 'ui/window'
local MakeCircle = require 'system/drawables/make_circle'
local MakeRect = require 'system/drawables/make_rect'
local Collider = require 'system/collider'

local intro = Gamestate.new()

function intro:init()
    self.frame = 0
    self.mouse_frame = 0

    self.pressLMB = nil
    self.floor = MakeRect(0, 0, 0, 0)
    self.moving_circle = MakeCircle(-1, -1, 20)
    self.static_circle = MakeCircle(100, 100, 20)
    self.player_circle = MakeCircle(-1, -1, 10)
    self.collider = Collider:new(self.player_circle, self.floor)
end

function intro:enter()
    print('BINGO intro:enter ' .. love.graphics.getHeight())
end

function intro:leave()
    print('BINGO intro:leave')
end

function intro:update(dt)
    self:move()
    self.collider:update(dt)
end

function intro:draw()
    love.graphics.push()
    love.graphics.setBackgroundColor(0, 0, 0, 1)
    love.graphics.setColor(1, 1, 1, 1)

    love.graphics.setFont(love.graphics.newFont(8))

    love.graphics.circle('fill', self.static_circle.x, self.static_circle.y, self.static_circle.r)
    love.graphics.circle('fill', self.moving_circle.x, self.moving_circle.y, self.moving_circle.r)
    love.graphics.circle('fill', self.player_circle.x, self.player_circle.y, self.player_circle.r)
    love.graphics.rectangle('fill', self.floor.x, self.floor.y, self.floor.w, self.floor.h)

    -- Draw instructions
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.setFont(love.graphics.newFont(12))
    love.graphics.print("Press SPACE to enter the Room Game", 10, window.height - 20)

    love.graphics.pop()
end

function intro:move()
    -- moving circle (simple time-based animation)
    self.moving_circle.y = 0.5 * window.height
    self.moving_circle.x = window.width * math.abs(math.sin(love.timer.getTime()) * 0.5 + 0.5)

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
        local click = MakeCircle(x * window.scale, y * window.scale, 1)

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
    
    if button == 'space' then
        Gamestate.switch('scenes/room_scene')
        return true
    end

    intro.collider:keypressed(button)
end

return intro
