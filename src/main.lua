-- Dependencies
local Gamestate = require 'vendor/gamestate'
local cli = require 'system/cli'
local FrameProducer = require 'system/frame_producer'

local window = require 'ui/window'

-- Load
function love.load(arg)
  if love.getVersion() < 11 then
    error("Love 11 or later is required")
  end

  love.graphics.setDefaultFilter('nearest', 'nearest')

  local args = cli.initialize(arg)

  Gamestate.switch('update', door, position)
end

function love.update(dt)
  local dt = FrameProducer:update(dt)

  if dt then
    Gamestate.update(dt)
  end
end

function love.draw()
  Gamestate.draw()
  FrameProducer:draw()
end

-- buttons
function buttonreleased(key)
  Gamestate.keyreleased(action)
end

function buttonpressed(key)
  Gamestate.keypressed(action)
end

function love.keyreleased(key, scancode)
  Gamestate.keyreleased(key, scancode)
end

function love.keypressed(key, scancode, isrepeat)
  Gamestate.keypressed(key, scancode, isrepeat)
end

function love.gamepadreleased(joystick, key)
end

function love.gamepadpressed(joystick, key)
end

function love.joystickremoved(joystick)
end

function love.joystickreleased(joystick, key)
end

function love.joystickpressed(joystick, key)
end

function love.joystickaxis(joystick, axis, value)
end
