StartView = View:extend
{
  startTile = Tile:new{
    x = 0,
    y = 0,
    image = "res/super_meter_maid_title.png"
  }
}

function StartView:onNew()
  self:add(self.startTile)
end
