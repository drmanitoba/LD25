DeathText = Text:extend
{
  font = { "res/Minecraftia.ttf", 24 },
  width = 350,
  height = 40
}

DeathView = View:extend
{
  deathTile = Tile:new{
    x = 0,
    y = 0,
    image = "res/death_screen.png"
  },
  deathText = DeathText:new{
    x = 50,
    y = 650,
    text = "Press 'z' to try again"
  },
}

function DeathView:onNew()
  self:add(self.deathTile)
  self:add(self.deathText)
end
