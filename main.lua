STRICT = true
DEBUG = true
require 'zoetrope'

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
  local direction = nil
  
  if the.app.lastDirection then
    print( "last direction was " .. the.app.lastDirection )
    if the.app.lastDirection == RIGHT or the.app.lastDirection == LEFT then
      print( "Testing left or right first" )
      if the.keys:pressed('a','left') then
        direction = LEFT
      elseif the.keys:pressed('d','right') then
        direction = RIGHT
      end
      
      if the.keys:pressed('w','up') then
        direction = UP
      elseif the.keys:pressed('s','down') then
        direction = DOWN
      end
    else
      print( "Testing up or down first" )
      if the.keys:pressed('w','up') then
        direction = UP
      elseif the.keys:pressed('s','down') then
        direction = DOWN
      end
      
      if the.keys:pressed('a','left') then
        direction = LEFT
      elseif the.keys:pressed('d','right') then
        direction = RIGHT
      end
    end
  else
    print( "Last direction was nill" )
    if the.keys:pressed('w','up') then
      direction = UP
    elseif the.keys:pressed('s','down') then
      direction = DOWN
    end
    
    if the.keys:pressed('a','left') then
      direction = LEFT
    elseif the.keys:pressed('d','right') then
      direction = RIGHT
    end
  end
  
  the.app.lastDirection = direction or the.app.lastDirection
  
  if the.player.canMove then
    if direction == UP then
      the.player:move(UP)
    elseif direction == DOWN then
      the.player:move(DOWN)
    elseif direction == LEFT then
      the.player:move(LEFT)
    elseif direction == RIGHT then
      the.player:move(RIGHT)
    end
    
    the.player.canMove = false
  end
  
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
  canMove = false,
  time = 0,
  updateTime = 0.5,
  targetX = 0,
  targetY = 0
}

function Player:onNew()
  self.targetX = self.x
  self.targetY = self.y
end

function Player:onUpdate( time )
  self.time = self.time + time
  if self.time > self.updateTime then
    self.time = self.updateTime
  end
  
  self.time = self.time % self.updateTime
  
  if self.time == 0 then
    self.canMove = true
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
