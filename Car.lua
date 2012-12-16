Car = MovingTile:extend
{
  image = "res/cars.png",
  width = 54,
  height = 108,
  drivingDirection = DOWN
}

function Car:checkForParking( dir )
  if dir == UP then
    --  Check for parking one tile up, one or two tiles to the right
  elseif dir == DOWN then
    --  Check for parking one tile down, one or two tile to the left
  end
end

function Car:onUpdate()
  -- Determine direction and checkForParking
  -- If it can park
  --   Park
  -- If it has run over the player
  --   Report collision and call insurance company
  -- Else
  --   Keep driving in current direction
end

RedCar = Car:extend
{
}

BlueCar = Car:extend
{
  imageOffset = { x = 55, y = 0 }
}
