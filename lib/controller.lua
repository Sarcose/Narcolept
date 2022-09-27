local baton = require 'lib.baton'

local controller = baton.new {
	controls = {
		left = {'key:left', 'axis:leftx-', 'button:dpleft'},
		right = {'key:right', 'axis:leftx+', 'button:dpright'},
		up = {'key:up', 'axis:lefty-', 'button:dpup'},
		down = {'key:down', 'axis:lefty+', 'button:dpdown'},
		action = {'key:x','key:space','key:return','button:a','mouse:1'},
		jump = {'key:z','button:b','mouse:2'},
        back = {'key:escape','key:z','button:b','mouse:2'},
        printglobal = {'key:p'},
        debug = {'key:`'},
        reset = {'key:r'},
	},
	pairs = {
		move = {'left', 'right', 'up', 'down'}
	},
	joystick = love.joystick.getJoysticks()[1],
	deadzone = .33,
}

return controller