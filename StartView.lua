StartText = Text:extend
{
  font = { "res/Minecraftia.ttf", 24 },
  width = 350,
  height = 40
}

StartView = View:extend
{
  startTile = Tile:new{
    x = 0,
    y = 0,
    image = "res/super_meter_maid_title.png"
  },
  startGameText = StartText:new{
    x = 390,
    y = 600,
    text = "Press 'enter' to start"
  },
  creditsText = StartText:new{
    x = 430,
    y = 400,
    font = { "res/Minecraftia.ttf", 18 },
    width = 400,
    text = "Art by: Mike Schondek \n" ..
    "Programming: Kyle Kellogg \n" ..
    "& Dan Barron \n" ..
    "Music by: Dwight Edwards"
  }
}

function StartView:onNew()
  self:add(self.startTile)
  self:add(self.startGameText)
  self:add(self.creditsText)
end
