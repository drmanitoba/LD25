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
  cars = nil,
  parkingSpaces = nil,
  carLayer = nil
}

function the.app:onRun()
  self.view = MapView:new()

  self.parkingSpaces = {}
  self.parkingSpaces[1] = {
    ["occupied"] = false,
    ["x"] = 54,
    ["y"] = math.round(54 * 0.5),
    ["height"] = 158
  }
  self.parkingSpaces[2] = {
    ["occupied"] = false,
    ["x"] = 54,
    ["y"] = math.round(54 * 3.5),
    ["height"] = 158
  }
  self.parkingSpaces[3] = {
    ["occupied"] = false,
    ["x"] = 54,
    ["y"] = math.round(54 * 6.5),
    ["height"] = 158
  }
  self.parkingSpaces[4] = {
    ["occupied"] = false,
    ["x"] = 54,
    ["y"] = math.round(54 * 9.5),
    ["height"] = 158
  }
  self.parkingSpaces[5] = {
    ["occupied"] = false,
    ["x"] = 54 * 12,
    ["y"] = math.round(54 * 9.5),
    ["height"] = 158
  }
  self.parkingSpaces[6] = {
    ["occupied"] = false,
    ["x"] = 54 * 12,
    ["y"] = math.round(54 * 6.5),
    ["height"] = 158
  }
  self.parkingSpaces[7] = {
    ["occupied"] = false,
    ["x"] = 54 * 12,
    ["y"] = math.round(54 * 3.5),
    ["height"] = 158
  }
  self.parkingSpaces[8] = {
    ["occupied"] = false,
    ["x"] = 54 * 12,
    ["y"] = math.round(54 * 0.5),
    ["height"] = 158
  }

  self.carLayer = Group:new()
  self:add( self.carLayer )

  self.cars = {}
  self:addCar( "red", DOWN )
  self:addCar( "blue", DOWN )
  self:addCar( "green", DOWN )
  self:addCar( "red", DOWN )
  self:addCar( "blue", DOWN )
  self:addCar( "green", DOWN )
  self:addCar( "red", UP )
  self:addCar( "blue", UP )
  self:addCar( "green", UP )
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
  self.carLayer:add( car )
end
