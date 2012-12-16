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
  parked = false,
  parking = false,
  parkingX = 0,
  parkingY = 0,
  parkingSpace = nil,
  lookingForParking = true,
  meter = nil,
  meterTime = math.random( 10, 20 ),
  unattendedTime = math.random( 10 ),
  flashPromise = nil
}

function Car:onNew()
  self:setDrivingDirection( self.drivingDirection )
end

function Car:onUpdate()
  if self.parked then
    return nil
  end
  
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
  self:checkForCollisions()

  self.x = self.x + self.moveX
  self.y = self.y + self.moveY

  --  Parking testing
  if self.parking then
    self:park()
    return nil
  else
    if self.lookingForParking and self:checkForParking() then
      return nil
    end
  end
  
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
  self.lookingForParking = true

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
  local lane = self.drivingDirection == UP and self.rightLane or self.leftLane

  if self.x == lane then
    while numSpaces > 0 do
      if self:checkForParkingSpace( the.app.parkingSpaces[ numSpaces ] ) then
        return true
      end
      numSpaces = numSpaces - 1
    end
  end

  return false
end

function Car:park()
  local halfX = self.drivingDirection == UP and self.x + ((self.parkingX - self.x) * 0.5) or self.x - ((self.x - self.parkingX) * 0.5)
  local speed = self.drivingDirection == UP and 0.25 or 0.09375
  
  self.lookingForParking = false
  
  --  TODO: Needs work; fine tune
  
  the.view.tween:start( self, 'x', halfX, speed )
  the.view.tween:start( self, 'y', self.parkingY, speed )
  the.view.tween:start( self, 'rotation', (self.drivingDirection == UP and self.upRot or self.downRot) + math.rad( 30 ), speed * 2 )
  :andThen(
    function()
      the.view.tween:start( self, 'x', self.parkingX, speed )
      the.view.tween:start( self, 'rotation', self.drivingDirection == UP and self.upRot or self.downRot, speed * 2 )
      :andThen(
        function()
          self.meter = Fill:new{
            fill = {0, 255, 0},
            width = 20,
            height = self.height,
            x = self.x + (self.drivingDirection == UP and (self.width + 26) or -46),
            y = self.y
          }
          the.app:add( self.meter )
          
          self:rerollTimes()
          self:startMeter()
        end
      )
    end
  )
  
  self.parking = false
  self.parked = true
end

function Car:startMeter()
  the.view.timer:after( self.meterTime, bind( self, "startWait" ) )
  the.view.tween:start( self.meter, "fill", { 255, 0, 0 }, self.meterTime )
end

function Car:startWait()
  the.view.timer:after( self.unattendedTime, bind( self, "driveOff" ) )
  self.flashPromise = the.view.timer:every( 0.1, bind( self, "flashMeter" ) )
end

function Car:driveOff()
  the.view.timer:stop( bind( self, "flashMeter" ) )
  the.app:remove( self.meter )
  
  local targX = self.drivingDirection == UP and self.rightLane or self.leftLane
  local halfX = self.drivingDirection == UP and math.floor((self.rightParkingX - targX) * 0.5) or math.floor((targX - self.leftParkingX) * 0.5)
  local halfH = math.floor( self.height * 0.5 )
  local speed = self.drivingDirection == UP and 0.25 or 0.09375
  
  the.view.tween:start( self, 'x', self.x + (self.drivingDirection == UP and -halfX or halfX), speed )
  the.view.tween:start( self, 'rotation', (self.drivingDirection == UP and self.upRot or self.downRot) - math.rad( 30 ), speed * 2 )
  :andThen(
    function()
      the.view.tween:start( self, 'y', self.parkingY + (self.drivingDirection == UP and -halfH or halfH), speed )
      the.view.tween:start( self, 'x', self.drivingDirection == UP and self.rightLane or self.leftLane, speed )
      the.view.tween:start( self, 'rotation', self.drivingDirection == UP and self.upRot or self.downRot, speed * 2 )
      :andThen(
        function()
          self.parked = false
          self.parking = false
          self.parkingSpace[ "occupied" ] = false
        end
      )
    end
  )
end

function Car:flashMeter()
  self.meter.fill = self.meter.fill[2] == 255 and {255,0,0} or {255,255,0}
end

function Car:rerollTimes()
  self.meterTime = math.random( 10, 20 )
  self.unattendedTime = math.random( 10 )  
end

function Car:checkForParkingSpace( space )
  local halfSpaceH = math.floor( space[ "height" ] * 0.5 )
  local halfH = math.floor( self.height * 0.5 )
  local parkingX = self.drivingDirection == UP and self.rightParkingX or self.leftParkingX
  local parkingY = space[ "y" ] + halfSpaceH
  local yDist = self.drivingDirection == UP and self.y - parkingY or parkingY - self.y
  
  if space[ "x" ] == parkingX then
    if yDist < self.height then
      if not space[ "occupied" ] then
        self.parkingX = space[ "x" ]
        self.parkingY = parkingY - halfH
        space[ "occupied" ] = true
        self.parking = true
        self.parkingSpace = space
        return true
      end
    end
  end

  return false
end

function Car:checkForCollisions()
  local idx = table.getn( the.app.cars )
  local car = nil

  while idx > 0 do
    car = the.app.cars[ idx ]

    if car == self then
      break
    end
    if car.parked or car.parking then
      break
    end

    if self:collide( car ) or
      car:collide( self ) then
      if self.drivingDirection == UP then
        if car.y < self.y then
          self.y = car.y + car.height
          self.moveY = math.min( car.moveY, self.height / math.random( 10, 30 ) )
        else
          car.y = self.y + self.height
          car.moveY = math.min( self.moveY, car.height / math.random( 10, 30 ) )
        end
      else
        if car.y > self.y then
          self.y = car.y - car.height
          self.moveY = math.min( car.moveY, self.height / math.random( 10, 30 ) )
        else
          car.y = self.y - self.height
          car.moveY = math.min( self.moveY, car.height / math.random( 10, 30 ) )
        end

        return true
      end
    end

    idx = idx - 1
  end

  return false
end

---------------------------------------------------------------------------------

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
