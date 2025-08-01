local cli = require 'vendor/cliargs'

local object = {}

object.initialize = function(arg)
  cli:add_option("--console", "Displays print info")
  cli:add_option("--fused", "Passed in when the app is running in fused mode")
  cli:add_option("--reset-saves", "Resets all the saves")
  cli:add_option("-b, --bbox", "Draw all bounding boxes ( enables memory debugger )")
  cli:add_option("-c, --character=NAME", "The character to use in the game")
  cli:add_option("-d, --debug", "Enable Memory Debugger")
  cli:add_option("-l, --level=NAME", "The level to display")
  cli:add_option("-m, --money=COINS", "Give your character coins ( requires level flag )")
  cli:add_option("-n, --locale=LOCALE", "Local, defaults to en-US")
  cli:add_option("-o, --costume=NAME", "The costume to use in the game")
  cli:add_option("-p, --position=X,Y", "The positions to jump to ( requires level )")
  cli:add_option("-r, --door=NAME", "The door to jump to ( requires level )")
  cli:add_option("-t, --test", "Run all the unit tests")
  cli:add_option("-w, --wait", "Wait for three seconds")
  cli:add_option("-v, --vol-mute=CHANNEL", "Disable sound: all, music, sfx")
  cli:add_option("-x, --cheat=ALL/CHEAT1,CHEAT2", "Enable certain cheats ( some require level to function, else will crash with collider is nil )")

  local args = cli:parse(arg)

  if not args then
    error("could not parse command line arguments")
  end

  return args
end

return object