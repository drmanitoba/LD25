DingText = Text:extend
{
  font = { "res/Minecraftia.ttf", 20 },
  width = 100,
  height = 20,
  tint = { 1, 1, 0 },
  onUpdate = function (self)
    self.text = "+$150"
  end
}
