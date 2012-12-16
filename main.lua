STRICT = true
DEBUG = true
require 'zoetrope'
require 'MovingTile'
require 'Car'
require 'Player'
require 'MapView'

---------------------------------------------------------------------------------------------------------

function math.round( val )
  local a = math.floor( val )
  local b = math.ceil( val )
  local c = val - a
  local d = b - val

  if c > d then
    return b
  else
    return a
  end
end

---------------------------------------------------------------------------------------------------------

the.app = App:new
{
  fps = 30
}

function the.app:onRun()
  self.view = MapView:new()

  redCar = RedCar:new{ x = 108, y = 0}
  blueCar = BlueCar:new{ x = 432, y = 0}
  greenCar = GreenCar:new{ x = 162, y = 108}
  self:add(redCar)
  self:add(blueCar)
  self:add(greenCar)
end

function the.app:onStartFrame()
end

function the.app:onUpdate( time )
  --  For each car, handle check to see if parking is available
end

function the.app:onEndFrame()
end
