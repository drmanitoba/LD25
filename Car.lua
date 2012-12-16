Car = MovingTile:extend
{
  image = "res/cars.png",
  width = 54,
  height = 108,
  drivingDirection = DOWN,
  targetX = 0,
  targetY = 0,
  moveX = 0,
  moveY = 0
}

function Car:onNew()
  self:setDrivingDirection( self.drivingDirection )
end

function Car:onUpdate()
  if self.drivingDirection == DOWN then
    self.targetY = the.app.height + self.height
    
    if self.y >= self.targetY then
      self:setDrivingDirection( UP )
    end
  else
    self.targetY = -self.height
    if self.moveY >= 0 then
      self.moveY = self:randomizeMoveY( true )
    end
    
    if self.y <= self.targetY then
      self:setDrivingDirection( DOWN )
    end
  end
  
  --  Collision testing
  
  --  Parking testing
  
  self.x = self.x + self.moveX
  self.y = self.y + self.moveY
  -- Determine direction and checkForParking
  -- If it can park
  --   Park
  -- If it has run over the player
  --   Report collision and call insurance company
  -- Else
  --   Keep driving in current direction
end

function Car:setDrivingDirection( dir )
  self.drivingDirection = dir
  
  if dir == DOWN then
    self.targetY = the.app.height + self.height
    self.moveY = self:randomizeMoveY( false )
    self.x = 54 * math.random( 2, 5 )
    self.y = -self.height
  else
    self.targetY = -self.height
    self.moveY = self:randomizeMoveY( true )
    self.x = 54 * math.random( 8, 11 )
    self.y = the.app.height + self.height
  end
end

function Car:randomizeMoveY( negative )
  local my = self.height / math.random( 10, 30 )
  
  return negative and -my or my
end

function Car:checkForParking( dir )
  if dir == UP then
    --  Check for parking one tile up, one or two tiles to the right
  elseif dir == DOWN then
    --  Check for parking one tile down, one or two tile to the left
  end
end

RedCar = Car:extend
{
}

BlueCar = Car:extend
{
  imageOffset = { x = 55, y = 0 }
}

GreenCar = Car:extend
{
  imageOffset = { x = 110, y = 0 }
}
