STRICT = true
DEBUG = true
require 'zoetrope'

the.app = App:new
{
}

function the.app.onRun( self )
  self.view = MapView:new()
end

function the.app.moveY( object, positive )
  if positive then
    --  Move object one tile up
  else
    --  Move object one tile down
  end
end

function the.app.moveX( object, positive )
  if positive then
    --  Move object one tile right
  else
    --  Move object one tile left
  end
end

function the.app.checkForParking( object, positive )
  if positive then
    --  Check for parking one tile up, one tile to the right
  else
    --  Check for parking one tile down, one tile to the left
  end
end

MapView = View:extend
{
  onNew = function(self)
    self:loadLayers("res/map.lua")
    self:clampTo(self.map)
  end
}
