STRICT = true
DEBUG = true
require 'zoetrope'
require 'MovingTile'
require 'Car'
require 'Player'
require 'MapView'
require 'Score'
require 'DingText'
require 'StartView'

---------------------------------------------------------------------------------------------------------
START = "startState"
MAIN_GAME = "mainGameState"
DEATH = "deathState"
FIRED = "firedState"

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
  gameMusic = nil,
  gameState = START
}

function the.app:onRun()
  self.gameMusic = sound("res/main_music.mp3")
  the.app:initStart()
end

function the.app:initStart()
  self.view = StartView:new()
end

function the.app:initGame()
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

  self.gameMusic:setLooping(true)
  self.gameMusic:play()
end

function the.app:onStartFrame()
end

function the.app:onUpdate( time )

  if the.app.gameState == START then
    self:startUpdate( time )
  elseif the.app.gameState == MAIN_GAME then
    self:gameUpdate( time )
  elseif the.app.gameState == DEATH then
    self:deathUpdate( time )
  elseif the.app.gameState == FIRED then
    self:firedUpdate( time )
  end
end

function the.app:startUpdate( time )
  if the.keys:pressed('z') then
    the.app:initGame()
    the.app.gameState = MAIN_GAME
  end
end

function the.app:gameUpdate( time )
  if the.keys:pressed('z') then
    local space
    local playerx = math.floor(the.player.x)

    -- Check if player x is 0 or 54*13
    if playerx > math.floor(54 * 12) then
      print("checking from the right")
      space = self:getParkingSpace( RIGHT, the.player.y )
    elseif playerx < 54 then
      print("checking from the left")
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
      --print( "player x: " .. px .. ", y: " .. py )
      --print( "car x: " .. cx .. ", y: " .. cy )
      --print( "car front: " .. cf )
      if math.floor( px + the.player.width ) >= cx and px <= math.floor( cx + car.width ) then
        if car.drivingDirection == UP then
          if py <= cb then
            if py >= math.floor( cf + (car.height * 0.25) ) and py <= cf then
              --print( "Up Front" )
              --  Front
              the.player:die()
            else
              --print( "Up Side" )
              --  Side
              the.player.x = (px > cx and math.floor( cx + car.width + 1 ) or math.floor( cx - the.player.width - 1 ))
              the.player.targetX = the.player.x
            end
          else
            --print( "Up Back" )
            --  Back
            the.player.x = (px > cx and math.floor( cx + car.width + 1 ) or math.floor( cx - the.player.width - 1 ))
            the.player.targetX = the.player.x
          end
        else
          if py >= cb then
            if py >= math.floor( cy + (car.height * 0.75)) and py <= cf then
              --print( "Down Front" )
              --  Front
              the.player:die()
            else
              --print( "Down Side" )
              --  Side
              the.player.x = (px > cx and math.floor( cx + car.width + 1 ) or math.floor( cx - the.player.width - 1 ))
              the.player.targetX = the.player.x
            end
          else
            --print( "Down Back" )
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
  local colX

  if dir == LEFT then
    colX = 54
  elseif dir == RIGHT then
    colX = 54 * 12
  end

  while idex > 0 do
    local space = self.parkingSpaces[ idex ]

    if space.occupied and colX == space.x then
      if space.car then
        if playerY >= space.car.y and playerY < space.car.y + space.car.height then
          return space
        end
      else
        return nil
      end
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
