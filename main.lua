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
end

function the.app:onStartFrame()
end

function the.app:onUpdate( time )
  --  For each car, handle check to see if parking is available
end

function the.app:onEndFrame()
end
