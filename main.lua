STRICT = true
DEBUG = true
require 'zoetrope'

the.app = App:new
{
  fps = 6
}

function the.app:onRun()
  self.view = MapView:new()
end

function the.app:onStartFrame()
end

function the.app:onUpdate( time )
  if the.keys:pressed('w') or the.keys:pressed('up') then
    --  Check if space above player is open
    the.player:move(UP)
  elseif the.keys:pressed('s') or the.keys:pressed('down') then
    --  Check if space below player is open
    the.player:move(DOWN)
  end
  
  if the.keys:pressed('a') or the.keys:pressed('left') then
    --  Check if space to the left of player is open
    the.player:move(LEFT)
  elseif the.keys:pressed('d') or the.keys:pressed('right') then
    --  Check if space to the right of player is open
    the.player:move(RIGHT)
  end
  
  --  For each car, handle check to see if parking is available
end

function the.app:onEndFrame()
end

---------------------------------------------------------------------------------------------------------

MovingTile = Tile:extend
{
}

function MovingTile:move( dir )
  if dir == UP then
    self.y = self.y - self.height
  elseif dir == DOWN then
    self.y = self.y + self.height
  elseif dir == LEFT then
    self.x = self.x - self.width
  elseif dir == RIGHT then
    self.x = self.x + self.width
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
