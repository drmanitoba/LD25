MapView = View:extend
{
}

function MapView:onNew()
  self:loadLayers("res/map.lua")
  self:clampTo(self.map)
end
