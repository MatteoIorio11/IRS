local halt_module = {}
local general_module = require("general")

-- Sense, check the motor ground sensor, the roboto tries to check if under Its motor the ground is black.
function halt_module.sense(robot)
	return check_ground(robot)
end

-- Callback, the robot has detected black as ground color. Stop.
function halt_module.callback(robot)
	log("Black on the ground, stop")
	general_module.CURRENT_VELOCITY = 0
	robot.wheels.set_velocity(general_module.CURRENT_VELOCITY, general_module.CURRENT_VELOCITY)
end

-- Check the ground and return True if the ground is black otherwise False.
function check_ground(robot)
	local error = 10e-2
	for i = 1, #robot.motor_ground do
		if robot.motor_ground[i].value <= error then
			return true
		end
	end
	return false
end

return halt_module
