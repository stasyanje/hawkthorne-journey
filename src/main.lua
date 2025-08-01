-- Dependencies
local Gamestate = require 'vendor/gamestate'
local cli = require 'system/cli'
local VideoSettings = require 'system/video_settings'

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

  -- Update video settings and check if frame is ready
  VideoSettings:update(dt)
  
  local video_system = VideoSettings:getVideoSystem()
  local current_frame = video_system.frame
  
  -- Only update gamestate when a new frame is ready
  if current_frame ~= (love._last_frame or 0) then
    love._last_frame = current_frame
    Gamestate.update(dt)
  end
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

-- Draw
function love.draw()
  -- Draw video settings (frame pacer + FPS slider)
  VideoSettings:draw()
  
  -- Only draw scene when frame is ready (same frame limiting as update)
  if love._last_frame and love._last_frame > 0 then
    Gamestate.draw()
  end
end

-- Override the default screenshot functionality so we can disable the fps before taking it
local captureScreenshot = love.graphics.captureScreenshot
function love.graphics.captureScreenshot(callback)
  window.dressing_visible = false
  love.draw()
  captureScreenshot(callback)
  window.dressing_visible = true
end
