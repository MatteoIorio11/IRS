local move_r= {}

function move_r.move(robot)
	local left_v = robot.random.uniform(0, 15)
	local right_v = robot.random.uniform(0, 15)
	robot.wheels.set_velocity(left_v, right_v)
end

return move_r 