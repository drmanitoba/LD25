STRICT = true
DEBUG = true
require 'zoetrope'

the.app = App:new
{
}

function the.app.onRun( self )
  self.view = MapView:new()
end

function the.app:onBeginFrame()
  --  For player, handle check to see if capable of movement (if moving)
  --  For each car, handle check to see if parking is available
end

function the.app:onUpdate( time )
  --  Handle updates
end

function the.app:onEndFrame()
  --  Check for input, flag as moving
end

MovingTile = Tile:extend
{
}

function MovingTile:move( dir )
  if dir == UP
    --  Move one tile up
  elseif dir == DOWN
    --  Move one tile down
  elseif dir == LEFT
    --  Move one tile left
  elseif dir == RIGHT
    --  Move one tile right
  end
end

function MovingTile:checkIfTileIsOpen( dir )
  if dir == UP
    --  Check if tile above is open
  elseif dir == DOWN
    --  Check if tile below is open
  elseif dir == LEFT
    --  Check if tile to the left is open
  elseif dir == RIGHT
    --  CHeck if tile to the right is open
  end
end

Car = MovingTile:extend
{ 
}

function Car:checkForParking( dir )
  if dir == UP
    --  Check for parking one tile up, one tile to the right
  elseif dir == DOWN
    --  Check for parking one tile down, one tile to the left
  end
end

Player = MovingTile:extend
{
}
end

MapView = View:extend
{
  onNew = function(self)
    self:loadLayers("res/map.lua")
    self:clampTo(self.map)
  end
}
