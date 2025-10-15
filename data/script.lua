local on_brake_percent = 0.05
local on_gas_percent = 0.02
local release_percent = 0.02
local overlap_time = 30 -- ms
local minimum_trigger_time = 150 -- ms

local triggered = false
local time_overlap = 0.0
local time_triggered = 0.0

local function ms(sec) return sec * 1000.0 end

function script.update(dt)
  local ph = ac.accessCarPhysics()
  local b = ph.brake or 0.0
  local g = ph.gas or 0.0
  local game_time = ms(dt)

  if b > on_brake_percent and g > on_gas_percent then
    time_overlap = time_overlap + game_time
  else
    time_overlap = 0.0
  end

  if (not triggered) and time_overlap >= overlap_time then
    triggered = true
    time_triggered = 0.0
  end

  if triggered then
    time_triggered = time_triggered + game_time
    ph.gas = 0.0

    if time_triggered >= minimum_trigger_time and b <= release_percent and g <= release_percent then
      triggered = false
      time_overlap = 0.0
    end
  end
end