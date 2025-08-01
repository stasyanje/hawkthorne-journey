-- Dependencies
local Gamestate = require 'vendor/gamestate'
local cli = require 'system/cli'

local window = require 'ui/window'

-- Load
function love.load(arg)
  local version = love.getVersion()

  if version < 11 then
    error("Love 11 or later is required")
  end

  local args = cli.initialize(arg)

  love.graphics.setDefaultFilter('nearest', 'nearest')
  Gamestate.switch('update', door, position)
end

-- Update
function love.update(dt)
  -- Clamp dt to prevent spiral of death, but allow for variable frame rates
  -- Max dt of 0.1 seconds (10 FPS minimum) to prevent huge jumps
  dt = math.min(0.1, dt)

  Gamestate.update(dt)
end

-- buttons
function buttonreleased(key)
  Gamestate.keyreleased(action)
end

function buttonpressed(key)
  Gamestate.keypressed(action)
end

function love.keyreleased(key, scancode)
end

function love.keypressed(key, scancode, isrepeat)
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

-- Draw
function love.draw()
  Gamestate.draw()
end

-- Override the default screenshot functionality so we can disable the fps before taking it
local captureScreenshot = love.graphics.captureScreenshot
function love.graphics.captureScreenshot(callback)
  window.dressing_visible = false
  love.draw()
  captureScreenshot(callback)
  window.dressing_visible = true
end
