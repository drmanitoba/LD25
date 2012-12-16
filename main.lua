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
  fps = 30,
  cars = nil
}

function the.app:onRun()
  self.view = MapView:new()
  
  self.cars = {}
  self:addCar( "red", DOWN )
  self:addCar( "blue", DOWN )
  self:addCar( "green", DOWN )
  self:addCar( "red", UP )
  self:addCar( "blue", UP )
  self:addCar( "green", UP )
end

function the.app:onStartFrame()
end

function the.app:onUpdate( time )
  --  For each car, handle check to see if parking is available
end

function the.app:onEndFrame()
end

function the.app:addCar( type, direction )
  local car = nil
  local dir = direction and direction or math.random()>0.5 and DOWN or UP
  local idx = math.max( table.getn(self.cars)+1, 1 )
  
  if type == "red" then
    car = RedCar:new{drivingDirection = dir}
  elseif type == "blue" then
    car = BlueCar:new{drivingDirection = dir}
  else
    car = GreenCar:new{drivingDirection = dir}
  end
  
  self.cars[ idx ] = car
  self:add( car )
end
