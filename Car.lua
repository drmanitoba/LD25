Car = MovingTile:extend
{
  image = "res/cars.png",
  width = 54,
  height = 108,
  paint = '',
  drivingDirection = DOWN,
  targetX = 0,
  targetY = 0,
  moveX = 0,
  moveY = 0,
  upRot = math.rad( 180 ),
  downRot = math.rad( 0 ),
  rightLane = 54 * 11,
  rightParkingX = math.floor( 54 * 12 ),
  leftLane = 54 * 2,
  leftParkingX = math.floor( 54 ),
  parked = false,
  parking = false,
  unattended = false,
  parkingX = 0,
  parkingY = 0,
  parkingSpace = nil,
  lookingForParking = true,
  meter = nil,
  meterTime = math.random( 10, 20 ),
  unattendedTime = math.random( 10 ),
  flashPromise = nil,
  hasTicket = false,
  ding = nil
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
end

function Car:setDrivingDirection( dir )
  local leftLanes = { 2, 3.5, 5 }
  local rightLanes = { 8, 9.5, 11 }
  self.drivingDirection = dir
  self.lookingForParking = true
  self.parking = false
  self.parked = false
  self.unattended = false

  if dir == DOWN then
    self.targetY = the.app.height
    self.moveY = self:randomizeMoveY( false )
    self.lane = leftLanes[math.random( table.getn(leftLanes) )]
    self.x = 54 * self.lane
    self.y = -self.height
    self.rotation = self.downRot

  else
    self.targetY = -self.height
    self.moveY = self:randomizeMoveY( true )
    self.lane = rightLanes[math.random( table.getn(rightLanes) )]
    self.x = 54 * self.lane
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
  the.view.tween:start( self, 'y', self:roundYToGrid( self.parkingY ), speed )
  the.view.tween:start( self, 'rotation', (self.drivingDirection == UP and self.upRot or self.downRot) + math.rad( 30 ), speed * 2 )
  :andThen(
    function()
      the.view.tween:start( self, 'x', self:roundXToGrid( self.parkingX ), speed )
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
          the.app.carLayer:add( self.meter )
          
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
  self.unattended = true
  
  the.view.timer:after( self.unattendedTime, bind( self, "driveOff" ) )
  self.flashPromise = the.view.timer:every( 0.1, bind( self, "flashMeter" ) )
end

function Car:driveOff()
  the.view.timer:stop( bind( self, "flashMeter" ) )

  self.parked = false
  self.parking = false
  
  -- need another flag for unparking

  if not self.hasTicket then
    -- Lose points
    playSound("res/strike.wav")
    the.app.score = the.app.score - 150
  end

  if the.app.carLayer:contains( self.meter ) then
    the.app.carLayer:remove( self.meter )
  end
  
  local targX = self.drivingDirection == UP and self.rightLane or self.leftLane
  local halfX = self.drivingDirection == UP and math.floor((self.rightParkingX - targX) * 0.5) or math.floor((targX - self.leftParkingX) * 0.5)
  local halfH = math.floor( self.height * 0.5 )
  local speed = self.drivingDirection == UP and 0.25 or 0.09375
  
  the.view.tween:start( self, 'x', self.x + (self.drivingDirection == UP and -halfX or halfX), speed )
  the.view.tween:start( self, 'rotation', (self.drivingDirection == UP and self.upRot or self.downRot) - math.rad( 30 ), speed * 2 )
  :andThen(
    function()
      the.view.tween:start( self, 'y', self.parkingY, speed )
      the.view.tween:start( self, 'x', self:roundXToGrid( self.drivingDirection == UP and self.rightLane or self.leftLane ), speed )
      the.view.tween:start( self, 'rotation', self.drivingDirection == UP and self.upRot or self.downRot, speed * 2 )
      :andThen(
        function()
          self.parkingSpace[ "occupied" ] = false
          self.parkingSpace[ "car" ] = nil
          self.parkingSpace = nil
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
        self.parkingX = self:roundXToGrid( space[ "x" ] )
        self.parkingY = self:roundYToGrid( parkingY - halfH )
        space[ "occupied" ] = true
        space[ "car" ] = self
        self.parking = true
        self.parkingSpace = space
        return true
      end
    end
  end

  return false
end

function Car:checkForCollisions()
  local sid = table.getIndex( the.app.cars, self )
  local idx = table.getn( the.app.cars )
  local car = nil

  while idx > 0 do
    car = the.app.cars[ idx ]

    if ( sid and sid == idx ) then-- or car.parked or car.parking then
      break
    end

    if self:collide( car ) then
      if self.drivingDirection == UP then
        if car.y <= self.y then
          self.y = car.y + car.height
          self.moveY = math.min( car.moveY, self.height / math.random( 10, 30 ) )
        else
          car.y = self.y + self.height
          car.moveY = math.min( self.moveY, car.height / math.random( 10, 30 ) )
        end
      else
        if car.y >= self.y then
          self.y = car.y - car.height
          self.moveY = math.min( car.moveY, self.height / math.random( 10, 30 ) )
        else
          car.y = self.y - self.height
          car.moveY = math.min( self.moveY, car.height / math.random( 10, 30 ) )
        end
      end
    end

    idx = idx - 1
  end

  return false
end

function Car:dingCar()
  self.ding = DingText:new{ x = self.x, y = self.y }
  the.app.playerLayer:add(self.ding)

  the.view.tween:start( self.ding, "alpha", 0, 3)
  :andThen(bind(self, "removeDing"))
end

function Car:removeDing()
  the.app.playerLayer:remove(self.ding)
end

---------------------------------------------------------------------------------

RedCar = Car:extend
{
  paint = 'red'
}

BlueCar = Car:extend
{
  imageOffset = { x = 55, y = 0 },
  paint = 'blue'
}

GreenCar = Car:extend
{
  imageOffset = { x = 110, y = 0 },
  paint = 'green'
}
