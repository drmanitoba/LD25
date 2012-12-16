Score = Text:extend
{
  font = { "res/ice_pixel-7.ttf", 54 },
  width = 300,
  height = 20,
  onUpdate = function (self)
    self.text = 'Score: ' .. the.app.score
  end
}
