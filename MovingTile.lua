MovingTile = Tile:extend
{
  movingUp = false,
  movingDown = false,
  movingLeft = false,
  movingRight = false
}

function MovingTile:move( dir )
  if dir == UP then
    self.y = math.max( 0, self.y - self.height )
  elseif dir == DOWN then
    self.y = math.min( the.app.height - self.height, self.y + self.height )
  elseif dir == LEFT then
    self.x = math.max( 0, self.x - self.width )
  elseif dir == RIGHT then
    self.x = math.min( the.app.width - self.width, self.x + self.width )
  end
end

function MovingTile:checkIfTileIsOpen( dir )
  if dir == UP then
    --  Check if tile above is open
  elseif dir == DOWN then
    --  Check if tile below is open
  elseif dir == LEFT then
    --  Check if tile to the left is open
  elseif dir == RIGHT then
    --  CHeck if tile to the right is open
  end
end

function MovingTile:distance( xval, yval )
  local a = 0
  local b = 0
  if type(xval) ~= "number" then
    a = xval.x
    b = xval.y
  else
    a = xval
    b = yval
  end
  
  a = self.x - a
  b = self.y - b
  return math.sqrt( a*a + b*b ) 
end

function MovingTile:roundXToGrid( x )
  local gs = math.floor( the.app.width / the.app.view.gridSize ) - 1
  local mx = math.floor( x / the.app.view.gridSize )
  local rt = math.min( gs, mx )
  rt = math.max( rt, 0 )
  return math.floor( rt * the.app.view.gridSize )
end

function MovingTile:roundYToGrid( y )
  local gs = math.floor( the.app.height / the.app.view.gridSize ) - 1
  local my = math.floor( y / the.app.view.gridSize )
  local rt = math.min( gs, my )
  rt = math.max( rt, 0 )
  return math.floor( rt * the.app.view.gridSize )
end
