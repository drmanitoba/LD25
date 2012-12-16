MapView = View:extend
{
}

function MapView:onNew()
  self:loadLayers("res/mm_map.lua")
  self:clampTo(self.map)
end
