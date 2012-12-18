Player = MovingTile:extend
{
  x = 0,
  y = 0,
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
  self.x = 0
  self.y = 0
  self:resetTargets()
  self.moveX = the.app.view.gridSize / 5
  self.moveY = the.app.view.gridSize / 5
end

function Player:resetTargets()
  self.x = self:roundXToGrid( self.x )
  self.y = self:roundYToGrid( self.y )
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

function Player:fire()
  self.solid = false
  self.active = false
end

function Player:kill()
  self:fire()
  self.imageOffset = { x = 54, y = 0 }
end

function Player:onUpdate( time )
  if self.changingPositionCounter > 0 then
    self.changingPositionCounter = self.changingPositionCounter - 1
    return nil
  end
  
  if the.keys:pressed( 'a', 'left' ) then
    self:changePosition( LEFT )
    self.x = self:roundXToGrid( math.max( 0, self.x - the.app.view.gridSize ) )
  elseif the.keys:pressed( 'd', 'right' ) then
    self:changePosition( RIGHT )
    self.x = self:roundXToGrid( math.min( the.app.width - the.app.view.gridSize, self.x + the.app.view.gridSize ) )
  elseif the.keys:pressed( 'w', 'up' ) then
    self:changePosition( UP )
    self.y = self:roundYToGrid( math.max( 0, self.y - the.app.view.gridSize ) )
  elseif the.keys:pressed( 's', 'down' ) then
    self:changePosition( DOWN )
    self.y = self:roundYToGrid( math.min( the.app.height - the.app.view.gridSize, self.y + the.app.view.gridSize ) )
  end
end
