STRICT = true
DEBUG = true
require 'zoetrope'
require 'MovingTile'
require 'Car'
require 'Player'
require 'MapView'
require 'Score'
require 'DingText'

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
  score = 0,
  gameMusic = nil
}

function the.app:onRun()
  self.view = MapView:new()
  self.hud = Score:new{ x = 10, y = 10 }
  self.gameMusic = sound("res/main_music.mp3")

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

  self.gameMusic:setLooping(true)
  self.gameMusic:play()
end

function the.app:onStartFrame()
end

function the.app:onUpdate( time )
  if the.keys:pressed('z') then
    local space
    local playerx = math.floor(the.player.x)

    -- Check if player x is 0 or 54*13
    if playerx > math.floor(54 * 12) and playerx <= math.floor(54 * 13) then
      space = self:getParkingSpace( RIGHT, the.player.y )
    elseif playerx >= 0 and playerx < 54 then
      space = self:getParkingSpace( LEFT, the.player.y )
    end

    if space then
      if space.occupied and space.car and space.car.parked and space.car.unattended then
        space.car.unattended = false
        space.car.hasTicket = true
        if the.app.carLayer:contains( space.car.meter ) then
          the.app.carLayer:remove( space.car.meter )
        end
        space.car:dingCar()
        playSound("res/ticket.wav")
        the.app.score = the.app.score + 150
      end
    end
  end
  
  local idx = table.getn( self.cars )
  local car
  local cx
  local cy
  local cf
  local cb
  local px = math.floor( the.player.x )
  local py = math.floor( the.player.y )
  while idx > 0 do
    car = self.cars[idx]
    cx = math.floor( car.x )
    cy = math.floor( car.y )
    cf = math.floor( (car.drivingDirection == UP and cy or cy + car.height) )
    cb = math.floor( (car.drivingDirection == UP and cy + car.height or cy) )
    if not car.parked and not car.parking and car:collide( the.player ) then
      print( "player x: " .. px .. ", y: " .. py )
      print( "car x: " .. cx .. ", y: " .. cy )
      print( "car front: " .. cf )
      if math.floor( px + the.player.width ) >= cx and px <= math.floor( cx + car.width ) then
        if car.drivingDirection == UP then
          if py <= cb then
            if py >= math.floor( cf + (car.height * 0.25) ) and py <= cf then
              print( "Up Front" )
              --  Front
              the.player:die()
            else
              print( "Up Side" )
              --  Side
              the.player.x = (px > cx and math.floor( cx + car.width + 1 ) or math.floor( cx - the.player.width - 1 ))
              the.player.targetX = the.player.x
            end
          else
            print( "Up Back" )
            --  Back
            the.player.x = (px > cx and math.floor( cx + car.width + 1 ) or math.floor( cx - the.player.width - 1 ))
            the.player.targetX = the.player.x
          end
        else
          if py >= cb then
            if py >= math.floor( cy + (car.height * 0.75)) and py <= cf then
              print( "Down Front" )
              --  Front
              the.player:die()
            else
              print( "Down Side" )
              --  Side
              the.player.x = (px > cx and math.floor( cx + car.width + 1 ) or math.floor( cx - the.player.width - 1 ))
              the.player.targetX = the.player.x
            end
          else
            print( "Down Back" )
            --  Back
            the.player.x = (px > cx and math.floor( cx + car.width + 1 ) or math.floor( cx - the.player.width - 1 ))
            the.player.targetX = the.player.x
          end
        end
      end
    end
    
    idx = idx - 1
  end
end

function the.app:onEndFrame()
end

function the.app:getParkingSpace( dir, playerY )
  local idex = table.getn( self.parkingSpaces )
  local side
  local atX

  while idex > 0 do
    space = self.parkingSpaces[ idex ]

    if dir == LEFT then
      side = math.floor(54)
      atX = side >= space.x
    else
      side = math.floor(54 * 12)
      atX = side >= space.x - 54
    end

    if not space.car then return end
    if atX and ( playerY >= space.car.y and playerY < space.car.y + space.car.height ) then
      return space
    end

    idex = idex - 1
  end
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
