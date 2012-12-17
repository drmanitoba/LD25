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
require 'DeathView'

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

function table.getIndex( t, v )
  local idx = nil
  local i = table.getn( t )
  while i > 0 do
    if t[i] == v then
      idx = i
      break
    end
    
    i = i - 1
  end
  
  return idx
end

---------------------------------------------------------------------------------------------------------

the.app = App:new
{
  fps = 30,
  cars = nil,
  parkingSpaces = nil,
  carLayer = nil,
  playerLayer = nil,
  lastPlayerPos = nil,
  score = 0,
  gameMusic = nil,
  gameState =  nil
}

function the.app:onRun()
  self.gameMusic = sound("res/main_music.mp3")
  the.app:initStart()
end

function the.app:initStart()
  the.app.gameState = START
  self.view = StartView:new()
end

function the.app:initDeath()
  the.app.gameState = DEATH
  self.view = DeathView:new()
end

function the.app:initGame()
  self.view = MapView:new()
  self.view.gridSize = 54
  self.hud = Score:new{ x = 10, y = 10 }

  self.parkingSpaces = {}
  self.parkingSpaces[1] = {
    ["occupied"] = false,
    ["x"] = 54,
    ["y"] = math.floor(54),
    ["height"] = 158,
    ["car"] = nil
  }
  self.parkingSpaces[2] = {
    ["occupied"] = false,
    ["x"] = 54,
    ["y"] = math.floor(54 * 4),
    ["height"] = 158,
    ["car"] = nil
  }
  self.parkingSpaces[3] = {
    ["occupied"] = false,
    ["x"] = 54,
    ["y"] = math.floor(54 * 7),
    ["height"] = 158,
    ["car"] = nil
  }
  self.parkingSpaces[4] = {
    ["occupied"] = false,
    ["x"] = 54,
    ["y"] = math.floor(54 * 10),
    ["height"] = 158,
    ["car"] = nil
  }
  self.parkingSpaces[5] = {
    ["occupied"] = false,
    ["x"] = 54 * 12,
    ["y"] = math.floor(54 * 10),
    ["height"] = 158,
    ["car"] = nil
  }
  self.parkingSpaces[6] = {
    ["occupied"] = false,
    ["x"] = 54 * 12,
    ["y"] = math.floor(54 * 7),
    ["height"] = 158,
    ["car"] = nil
  }
  self.parkingSpaces[7] = {
    ["occupied"] = false,
    ["x"] = 54 * 12,
    ["y"] = math.floor(54 * 4),
    ["height"] = 158,
    ["car"] = nil
  }
  self.parkingSpaces[8] = {
    ["occupied"] = false,
    ["x"] = 54 * 12,
    ["y"] = math.floor(54),
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
      space = self:getParkingSpace( RIGHT, the.player.y )
    elseif playerx < 54 then
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
  
  if self.lastPlayerPos then
    local idx = table.getn( self.cars )
    local car
    local side
    
    while idx > 0 do
      car = self.cars[ idx ]
      
      if car:collide( the.player ) then
        --print( 'car x: ' .. car.x .. ', y: ' .. car.y )
        --print( 'pla x: ' ..self.lastPlayerPos[1] .. ', y: ' .. self.lastPlayerPos[2] )
        --print( 'car driving direction: ' .. car.drivingDirection )
        
        if self.lastPlayerPos[1] >= car:roundXToGrid( car.x ) and self.lastPlayerPos[1] <= car:roundXToGrid( car.x + the.app.view.gridSize ) then
          if self.lastPlayerPos[2] <= car:roundYToGrid( car.y ) then
            side = UP
          elseif self.lastPlayerPos[2] >= car:roundYToGrid( car.y + ( the.app.view.gridSize * 2 ) ) then
            side = DOWN
          else
            side = car.drivingDirection == UP and DOWN or UP
          end
        else
          if self.lastPlayerPos[1] < car:roundXToGrid( car.x ) then
            side = LEFT
          else
            side = RIGHT
          end
        end
        
        --print( 'side: ' .. side )
        --print( 'parking? ' .. tostring( car.parking ) .. ' parked? ' .. tostring( car.parked ) )
        
        if car.parking or car.parked or car.drivingDirection ~= side then
          if side == UP or side == DOWN then
            the.player.y = self.lastPlayerPos[2]
          else
            the.player.x = self.lastPlayerPos[1]
          end
          
          the.player.targetX = the.player.x
          the.player.targetY = the.player.y
        else
          the.player:die()
          the.app.view:flash( {255,0,0}, 0.05 )
        end
      end
      
      idx = idx - 1
    end
  end
  
  self.lastPlayerPos = { math.floor( the.player.x ), math.floor( the.player.y ) }
end

function the.app:deathUpdate()
  if the.keys:pressed('z') then
    the.app:initGame()
    the.app.gameState = MAIN_GAME
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
