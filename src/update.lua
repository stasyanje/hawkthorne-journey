local Gamestate = require 'vendor/gamestate'
local window = require 'ui/window'

local screen = Gamestate.new()

function screen:enter()
    self.message = ""
    self.progress = 0
    self.time = 0
end

function screen:update(dt)
    self.time = self.time + dt
    Gamestate.switch('scenes/intro_scene')
end

function screen:leave()
    love.graphics.setColor(1, 1, 1, 1)
end

function screen:keypressed(button)
end

function screen:draw()
    if self.progress > 0 then
        love.graphics.setColor(1, 1, 1)
        love.graphics.rectangle("line", 40, window.height - 75, window.width - 80, 10)
        love.graphics.rectangle("fill", 40, window.height - 75, (window.width - 80) * self.progress / 100, 10)
        love.graphics.printf(self.message, 40, window.height - 55, window.width - 80, 'center')
    end
end

return screen
