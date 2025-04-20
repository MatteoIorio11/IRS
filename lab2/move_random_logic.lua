local generalmodule = require("general")
local moverandommodule = {}

-- #NOTE: logic for move the robot with random speeds.
function moverandommodule.sense(robot)
	return true
end

-- Logic for moving the robot randomly.
function moverandommodule.callback(robot)
	log("robot: Priority over move random task")
	local left_v = robot.random.uniform(0, generalmodule.MAX_VELOCITY)
	local right_v = robot.random.uniform(0, generalmodule.MAX_VELOCITY)
	robot.wheels.set_velocity(left_v, right_v)
end

return moverandommodule
