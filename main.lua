STRICT = true
DEBUG = true
require 'zoetrope'

the.app = App:new
{
	onRun = function (self)
    self.view = MapView:new()
	end
}

MapView = View:extend{
  onNew = function(self)
    self:loadLayers("res/map.lua")
    self:clampTo(self.map)
  end
}
