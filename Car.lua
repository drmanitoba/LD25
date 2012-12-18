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
  unparking = false,
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
  if self.parked or self.unparking then
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
  self.unparking = false
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
  local ty = self:roundYToGrid( self.parkingY )
  local tx = self:roundXToGrid( self.parkingX )
  local dy = math.floor( self.drivingDirection == UP and self.y - ty or ty - self.y )
  local yc = dy * 0.5
  local y1 = math.floor( self.drivingDirection == UP and self.y - yc or self.y + yc )
  local tr = self.rotation
  local r1 = tr + math.rad( 30 )
  local sp = 0.25
  local hs = 0.125
  
  self.lookingForParking = false
  
  the.view.tween:start( self, 'y', y1, sp )
  :andThen(
    function()
      the.view.tween:start( self, 'x', tx, sp )
      the.view.tween:start( self, 'y', ty, sp )
      the.view.tween:start( self, 'rotation', r1, hs )
      :andThen(
        function()
          the.view.tween:start( self, 'rotation', tr, hs )
          :andThen(
            function()
              local hw = math.floor( the.app.view.gridSize * 0.5 )
              local mx = math.floor( self.drivingDirection == UP and the.app.width - hw or hw - 20 )
              local my = self.y
              self.meter = Fill:new{
                fill = {0, 255, 0},
                width = 20,
                height = self.height,
                x = mx,
                y = my
              }
              the.app.carLayer:add( self.meter )
              
              self:rerollTimes()
              self:startMeter()
            end
          )
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
  self.unparking = true

  if not self.hasTicket then
    -- Lose points
    playSound("res/strike.wav")
    the.app.score = the.app.score - 150
  end

  if the.app.carLayer:contains( self.meter ) then
    the.app.carLayer:remove( self.meter )
  end
  
  local ty = self:roundYToGrid( self.drivingDirection == UP and self.parkingY - self.height or self.parkingY + self.height )
  local tx = self:roundXToGrid( self.drivingDirection == UP and self.parkingX - the.app.view.gridSize or self.parkingX + the.app.view.gridSize )
  local dy = math.floor( self.drivingDirection == UP and self.y - ty or ty - self.y )
  local yc = dy * 0.5
  local hh = self.height * 0.5
  local y1 = math.floor( self.drivingDirection == UP and self.y + hh or self.y - hh )
  local y2 = math.floor( self.drivingDirection == UP and self.y - yc or self.y + yc )
  local tr = self.rotation
  local r1 = tr - math.rad( 30 )
  local sp = 0.25
  local hs = 0.125
  
  the.view.tween:start( self, 'y', y1, sp )
  :andThen(
    function()
      the.view.tween:start( self, 'x', tx, sp )
      the.view.tween:start( self, 'y', ty, sp )
      the.view.tween:start( self, 'rotation', r1, hs )
      :andThen(
        function()
          the.view.tween:start( self, 'rotation', tr, hs )
          :andThen(
            function()
              self.parkingSpace[ "occupied" ] = false
              self.parkingSpace[ "car" ] = nil
              self.parkingSpace = nil
              self.unparking = false
            end
          )
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
    if yDist > 0 and yDist < self.height then
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

    if ( sid and sid == idx ) then
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
