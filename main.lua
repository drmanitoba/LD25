STRICT = true
DEBUG = true
require 'zoetrope'

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

---------------------------------------------------------------------------------------------------------

MovingTile = Tile:extend
{
  movingUp = false,
  movingDown = false,
  movingLeft = false,
  movingRight = false
}

function MovingTile:move( dir )
  if dir == UP then
    self.y = math.max( 0, self.y - self.height )
  elseif dir == DOWN then
    self.y = math.min( the.app.height - self.height, self.y + self.height )
  elseif dir == LEFT then
    self.x = math.max( 0, self.x - self.width )
  elseif dir == RIGHT then
    self.x = math.min( the.app.width - self.width, self.x + self.width )
  end
end

function MovingTile:checkIfTileIsOpen( dir )
  if dir == UP then
    --  Check if tile above is open
  elseif dir == DOWN then
    --  Check if tile below is open
  elseif dir == LEFT then
    --  Check if tile to the left is open
  elseif dir == RIGHT then
    --  CHeck if tile to the right is open
  end
end

function MovingTile:distance( xval, yval )
  local a = 0
  local b = 0
  if type(xval) ~= "number" then
    a = xval.x
    b = xval.y
  else
    a = xval
    b = yval
  end
  
  a = self.x - a
  b = self.y - b
  return math.sqrt( a*a + b*b ) 
end

---------------------------------------------------------------------------------------------------------

Car = MovingTile:extend
{
}

function Car:checkForParking( dir )
  if dir == UP then
    --  Check for parking one tile up, one tile to the right
  elseif dir == DOWN then
    --  Check for parking one tile down, one tile to the left
  end
end

function Car:onUpdate()
  
end

---------------------------------------------------------------------------------------------------------

Player = MovingTile:extend
{
  image = "res/player.png",
  isMoving = false,
  targetX = 0,
  targetY = 0,
  moveX = 0,
  moveY = 0,
  facing = UP
}

function Player:onNew()
  self.targetX = self.x
  self.targetY = self.y
  self.moveX = self.width / 5
  self.moveY = self.height / 5
end

function Player:onUpdate( time )
  if self:distance( self.targetX, self.targetY ) <= NEARLY_ZERO then
    if the.keys:pressed('a','left') then
      self.targetX = math.max( 0, self.x - self.width )
      self.facing = LEFT
    elseif the.keys:pressed('d','right') then
      self.targetX = math.min( the.app.width - self.width, self.x + self.width )
      self.facing = RIGHT
    elseif the.keys:pressed('w','up') then
      self.targetY = math.max( 0, self.y - self.height )
      self.facing = UP
    elseif the.keys:pressed('s','down') then
      self.targetY = math.min( the.app.height - self.height, self.y + self.height )
      self.facing = DOWN
    end
    
    if self:distance( self.targetX, self.targetY ) >= NEARLY_ZERO then
      self.isMoving = true
    else
      self.isMoving = false
    end
  end
  
  if self.isMoving then
    if self.facing == LEFT then
      self.x = math.max( 0, self.x - self.moveX )
    elseif self.facing == RIGHT then
      self.x = math.min( the.app.width - self.width, self.x + self.moveX )
    elseif self.facing == UP then
      self.y = math.max( 0, self.y - self.moveY )
    else
      self.y = math.min( the.app.height - self.height, self.y + self.moveY )
    end
  end
end

---------------------------------------------------------------------------------------------------------

MapView = View:extend
{
}

function MapView:onNew()
  self:loadLayers("res/map.lua")
  self:clampTo(self.map)
end
