MapView = View:extend
{
}

function MapView:onNew()
  --self:loadLayers("res/mm_map.lua")
  self:loadLayers("res/mm_map_lg.lua")
  self:clampTo(self.map)
end
