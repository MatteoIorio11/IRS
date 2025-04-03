local motor = {}

function motor.move(robot, vector)
	local L = robot.wheels.axis_length
	local left_v = vector.length - ((L * vector.angle)/2)
	local right_v = vector.length  + ((L * vector.angle)/2)
	robot.wheels.set_velocity(math.min(left_v,15), math.min(right_v, 15))
end

return motor
