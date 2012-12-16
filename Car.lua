Car = MovingTile:extend
{
  image = "res/cars.png",
  width = 54,
  height = 108,
  drivingDirection = DOWN,
  targetX = 0,
  targetY = 0,
  moveX = 0,
  moveY = 0,
  upRot = math.rad( 180 ),
  downRot = math.rad( 0 ),
  rightLane = 54 * 11,
  rightParkingX = 54 * 12,
  leftLane = 54 * 2,
  leftParkingX = 54,
  parked = false
}

function Car:onNew()
  self:setDrivingDirection( self.drivingDirection )
end

function Car:onUpdate()
  if self.parked then return end
  
  if self.drivingDirection == DOWN then
    if self.y >= self.targetY then
      self:setDrivingDirection( UP )
    end
  else
    if self.y <= self.targetY then
      self:setDrivingDirection( DOWN )
    end
  end
  
  --  Collision testing
  
  --  Parking testing
  if self:checkForParking() then return end
  
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
    self.targetY = the.app.height
    self.moveY = self:randomizeMoveY( false )
    self.x = 54 * math.random( 2, 5 )
    self.y = -self.height
    self.rotation = self.downRot
    
  else
    self.targetY = -self.height
    self.moveY = self:randomizeMoveY( true )
    self.x = 54 * math.random( 8, 11 )
    self.y = the.app.height
    self.rotation = self.upRot
  end
end

function Car:randomizeMoveY( negative )
  local my = self.height / math.random( 10, 30 )
  
  return negative and -my or my
end

function Car:checkForParking()
  local numSpaces = table.getn( the.app.parkingSpaces )
  
  if self.drivingDirection == UP then
    if self.x == self.rightLane then
      while numSpaces > 0 do
        if self:checkForParkingSpace( the.app.parkingSpaces[ numSpaces ] ) then return true end
        numSpaces = numSpaces - 1
      end 
    end
  else
    if self.x == self.leftLane then
      while numSpaces > 0 do
        if self:checkForParkingSpace( the.app.parkingSpaces[ numSpaces ] ) then return true end
        numSpaces = numSpaces - 1
      end 
    end
  end
  
  return false
end

function Car:checkForParkingSpace( space )
  local parkingX = self.drivingDirection == UP and self.rightParkingX or self.leftParkingX
  
  if space[ "x" ] == parkingX then
    if math.abs( space[ "y" ] - self.y ) < space[ "height" ] then
      if not space[ "occupied" ] then
        self.x = space[ "x" ]
        self.y = (space[ "y" ] + math.floor( space[ "height" ] * 0.5 )) - math.floor( self.height * 0.5 )
        space[ "occupied" ] = true
        self.parked = true
        return true
      end
    end
  end
  
  return false
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
