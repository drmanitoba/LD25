Car = MovingTile:extend
{
}

function Car:checkForParking( dir )
  if dir == UP then
    --  Check for parking one tile up, one tile to the right
  elseif dir == DOWN then
    --  Check for parking one tile down, one tile to the left
  end
end

function Car:onUpdate()
  
end

