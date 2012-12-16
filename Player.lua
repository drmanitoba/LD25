Player = MovingTile:extend
{
  image = "res/maid.png",
  isMoving = false,
  targetX = 0,
  targetY = 0,
  moveX = 0,
  moveY = 0,
  facing = UP,
  changingPositionCounter = 0,
  rightRad = math.rad(0),
  downRad = math.rad(90),
  leftRad = math.rad(180),
  upRad = math.rad(270)
}

function Player:onNew()
  self:resetTargets()
  self.moveX = self.width / 5
  self.moveY = self.height / 5
end

function Player:resetTargets()
  self.targetX = self.x
  self.targetY = self.y
end

function Player:changePosition( dir )
  if dir == LEFT then
    self.rotation = self.leftRad
  elseif dir == RIGHT then
    self.rotation = self.rightRad
  elseif dir == UP then
    self.rotation = self.upRad
  else
    self.rotation = self.downRad
  end
  
  self.isMoving = false
  self:resetTargets()
  self.changingPositionCounter = the.app.fps / 4
end

function Player:onUpdate( time )
  if self.changingPositionCounter > 0 then
    self.changingPositionCounter = self.changingPositionCounter - 1
    return
  end
  
  if self:distance( self.targetX, self.targetY ) <= NEARLY_ZERO then
    if the.keys:pressed('a','left') then
      self.targetX = math.max( 0, self.x - self.width )
      self.facing = LEFT
    elseif the.keys:pressed('d','right') then
      self.targetX = math.min( the.app.width - self.width, self.x + self.width )
      self.facing = RIGHT
    elseif the.keys:pressed('w','up') then
      self.targetY = math.max( 0, self.y - self.height )
      self.facing = UP
    elseif the.keys:pressed('s','down') then
      self.targetY = math.min( the.app.height - self.height, self.y + self.height )
      self.facing = DOWN
    end

    if self:distance( self.targetX, self.targetY ) >= NEARLY_ZERO then
      self.isMoving = true
    else
      self.isMoving = false
    end
  end

  if self.isMoving then
    if self.facing == LEFT then
      if self.rotation ~= self.leftRad then
        self:changePosition( LEFT )
      else
        self.x = math.max( 0, self.x - self.moveX )
      end
    elseif self.facing == RIGHT then
      if self.rotation ~= self.rightRad then
        self:changePosition( RIGHT )
      else
        self.x = math.min( the.app.width - self.width, self.x + self.moveX )
      end
    elseif self.facing == UP then
      if self.rotation ~= self.upRad then
        self:changePosition( UP )
      else
        self.y = math.max( 0, self.y - self.moveY )
      end
    else
      if self.rotation ~= self.downRad then
        self:changePosition( DOWN )
      else
        self.y = math.min( the.app.height - self.height, self.y + self.moveY )
      end
    end
  end
end
