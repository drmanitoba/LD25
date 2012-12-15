STRICT = true
DEBUG = true
require 'zoetrope'

the.app = App:new
{
	onRun = function (self)
		self:add(Fill:new{ width = 16, height = 16,
			x = (self.width - 16) / 2,
			y = (self.width - 16) / 2,
			fill = {0, 0, 255},
			velocity = { rotation = math.pi / 2 }
		})
	end
}
