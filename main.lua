STRICT = true
DEBUG = true
require 'zoetrope'

the.app = App:new
{
}

function the.app:onRun()
  self.view = MapView:new()
end

function the.app:onBeginFrame()
  if the.player.movingUp then
    --  Check if space above player is open
  elseif the.player.movingDown then
    --  Check if space below player is open
  end
  
  if the.player.movingLeft then
    --  Check if space to the left of player is open
  elseif the.player.movingRight then
    --  Check if space to the right of player is open
  end
  
  --  Reset player movement flags
  the.player.movingUp = false
  the.player.movingDown = false
  the.player.movingLeft = false
  the.player.movingRight = false
  
  --  For each car, handle check to see if parking is available
end

function the.app:onUpdate( time )
  --  Handle updates
end

function the.app:onEndFrame()
  if the.keys:pressed('w') or the.keys:pressed('up') then
    the.player.movingUp = true
    the.player.movingDown = false
  elseif the.keys:pressed('s') or the.keys:pressed('down') then
    the.player.movingDown = true
    the.player.movingUp = false
  end
  
  if the.keys:pressed('a') or the.keys:pressed('left') then
    the.player.movingLeft = true
    the.player.movingRight = false
  elseif the.keys:pressed('d') or the.keys:pressed('right') then
    the.player.movingRight = true
    the.player.movingLeft = true
  end
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
    --  Move one tile up
  elseif dir == DOWN then
    --  Move one tile down
  elseif dir == LEFT then
    --  Move one tile left
  elseif dir == RIGHT then
    --  Move one tile right
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
  image = "res/player.png"
}

function Player:onUpdate()
  
end

---------------------------------------------------------------------------------------------------------

MapView = View:extend
{
}

function MapView:onNew()
  self:loadLayers("res/map.lua")
  self:clampTo(self.map)
end
