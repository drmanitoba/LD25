STRICT = true
DEBUG = true
require 'zoetrope'

the.app = App:new
{
}

function the.app.onRun( self )
  self:add(Fill:new{ width = 16, height = 16,
		x = (self.width - 16) / 2,
		y = (self.height - 16) / 2,
		fill = {0, 0, 255},
		velocity = { rotation = math.pi / 2 }
	})
end

function the.app.moveY( object, positive )
  if positive then
    
  else
    
  end
end

function the.app.moveX( object, positive )
  if positive then
    
  else
    
  end
end