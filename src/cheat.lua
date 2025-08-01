local Cheat = {}

local cheatList = {}
local cheatEnabled = true

--if turnOn is true the cheat is enabled
-- if turnOn is false the cheat is disabled
local function setCheat(cheatName, turnOn)
  local toggles = {               -- FORMAT: {player attribute, true value, false value}
    jump_high = { 'jumpFactor', 1.44, 1 },
    super_speed = { 'speedFactor', 2, 1 },
    god = { 'godmode', true, false },
    slide_attack = { 'canSlideAttack', true, false },
  }
  local activations = {
    give_money = function() player.money = player.money + 10000 end,
    max_health = function() player.health = player.max_health end,
  }

  if activations[cheatName] then
    activations[cheatName]()
  end
end

function Cheat:is(cheatName)
  return cheatList[cheatName] and true or false
end

function Cheat:on(cheatName)
  if cheatEnabled then
    setCheat(cheatName, true)
  end
end

function Cheat:off(cheatName)
  setCheat(cheatName, false)
end

function Cheat:fairfight()
  cheatEnabled = false
  local cheats = false
  for cheat, _ in pairs(cheatList) do
    if self:is(cheat) then cheats = true end
    self:off(cheat)
  end
  return cheats
end

function Cheat:toggle(cheatName)
  setCheat(cheatName, not cheatList[cheatName])
end

return Cheat
