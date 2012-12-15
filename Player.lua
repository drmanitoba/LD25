Player = MovingTile:extend
{
  image = "res/player.png",
  isMoving = false,
  targetX = 0,
  targetY = 0,
  moveX = 0,
  moveY = 0,
  facing = UP
}

function Player:onNew()
  self.targetX = self.x
  self.targetY = self.y
  self.moveX = self.width / 5
  self.moveY = self.height / 5
end

function Player:onUpdate( time )
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
      self.x = math.max( 0, self.x - self.moveX )
    elseif self.facing == RIGHT then
      self.x = math.min( the.app.width - self.width, self.x + self.moveX )
    elseif self.facing == UP then
      self.y = math.max( 0, self.y - self.moveY )
    else
      self.y = math.min( the.app.height - self.height, self.y + self.moveY )
    end
  end
end
