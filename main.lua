STRICT = true
DEBUG = true
require 'zoetrope'
require 'MovingTile'
require 'Car'
require 'Player'
require 'MapView'
require 'Score'

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
  carLayer = nil,
  playerLayer = nil,
  score = 0
}

function the.app:onRun()
  self.view = MapView:new()
  self.hud = Score:new{ x = 10, y = 10 }

  self.parkingSpaces = {}
  self.parkingSpaces[1] = {
    ["occupied"] = false,
    ["x"] = 54,
    ["y"] = math.round(54 * 0.5),
    ["height"] = 158,
    ["car"] = nil
  }
  self.parkingSpaces[2] = {
    ["occupied"] = false,
    ["x"] = 54,
    ["y"] = math.round(54 * 3.5),
    ["height"] = 158,
    ["car"] = nil
  }
  self.parkingSpaces[3] = {
    ["occupied"] = false,
    ["x"] = 54,
    ["y"] = math.round(54 * 6.5),
    ["height"] = 158,
    ["car"] = nil
  }
  self.parkingSpaces[4] = {
    ["occupied"] = false,
    ["x"] = 54,
    ["y"] = math.round(54 * 9.5),
    ["height"] = 158,
    ["car"] = nil
  }
  self.parkingSpaces[5] = {
    ["occupied"] = false,
    ["x"] = 54 * 12,
    ["y"] = math.round(54 * 9.5),
    ["height"] = 158,
    ["car"] = nil
  }
  self.parkingSpaces[6] = {
    ["occupied"] = false,
    ["x"] = 54 * 12,
    ["y"] = math.round(54 * 6.5),
    ["height"] = 158,
    ["car"] = nil
  }
  self.parkingSpaces[7] = {
    ["occupied"] = false,
    ["x"] = 54 * 12,
    ["y"] = math.round(54 * 3.5),
    ["height"] = 158,
    ["car"] = nil
  }
  self.parkingSpaces[8] = {
    ["occupied"] = false,
    ["x"] = 54 * 12,
    ["y"] = math.round(54 * 0.5),
    ["height"] = 158,
    ["car"] = nil
  }

  self.carLayer = Group:new()
  self:add( self.carLayer )
  
  self.playerLayer = Group:new()
  self:add( self.playerLayer )
  self.view.player:remove( the.player )
  self.playerLayer:add( the.player )

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

  self:add( self.hud )
end

function the.app:onStartFrame()
end

function the.app:onUpdate( time )
  if the.keys:pressed('return') then
    local space
    local playerx = math.floor(the.player.x)

    -- Check if player x is 0 or 54*13
    if playerx == math.floor((54 * 13) - 1) then
      space = self:getParkingSpace( RIGHT, the.player.y )
    elseif playerx == 0 then
      space = self:getParkingSpace( LEFT, the.player.y )
    end

    if space and space.occupied and space.car.parked and space.car.unattended then
      space.car.unattended = false
      the.app.carLayer:remove( space.car.meter )
      the.app.score = the.app.score + 150
    end
  end
end

function the.app:onEndFrame()
end

function the.app:getParkingSpace( dir, playerY )
  local idex = table.getn( self.parkingSpaces )
  local side = dir == LEFT and 54 or 54 * 12

  while idex > 0 do
    space = self.parkingSpaces[ idex ]

    if not space.car then break end
    if side == space.x and ( playerY > space.car.y and playerY < space.car.y + space.car.height ) then
      return space
    end

    idex = idex - 1
  end

  return nil
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
