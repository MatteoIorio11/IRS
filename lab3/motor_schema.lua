local motor = {}

-- Move the robot using the input vector, this function uses the follow relation for retrieving the left and right velocity:
-- D: distance between the two wheels
-- Vl = vector.length - (D * vector.angle) / 2
-- Vr = vector.length + (D * vector.angle) / 2
function motor.move(robot, vector)
	local L = robot.wheels.axis_length
	local left_v = vector.length - ((L * vector.angle)/2)
	local right_v = vector.length  + ((L * vector.angle)/2)
	robot.wheels.set_velocity(math.min(left_v,15), math.min(right_v, 15))
end

return motor
