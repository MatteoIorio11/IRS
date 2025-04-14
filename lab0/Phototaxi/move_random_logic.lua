local generalmodule = require("general")
local moverandommodule = {}

-- Make the robot walk randomly.
function moverandommodule.callback(robot)
	local left_v = robot.random.uniform(0, generalmodule.MAX_VELOCITY)
	local right_v = robot.random.uniform(0, generalmodule.MAX_VELOCITY)
	robot.wheels.set_velocity(left_v, right_v)
end

return moverandommodule
