local Gamestate = require 'vendor/gamestate'
local window = require 'window'
local Fonts = require 'fonts'

local state = Gamestate.new()

function state:enter(previous)
    print('BINGO pause:enter')
    self.previous = previous
end

function state:draw()
    love.graphics.setFont(Fonts[Fonts._default])
    love.graphics.print("PAUSE")
end

function state:leave()
    print('BINGO pause:leave')
end

function state:mousepressed(x, y, button)
    
end

function state:keypressed(button)
    if button == 'START' then
        Gamestate.switch(self.previous)
        return true
    end
end

return state
