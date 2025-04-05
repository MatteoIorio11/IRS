local move_r= {}
local general = require("general")

local steps = 0

-- Basic implementation of random walking. This function set two different velocities for the wheels.
function move_r.move(robot)
	local left_v = robot.random.uniform(0, 15)
	local right_v = robot.random.uniform(0, 15)
	robot.wheels.set_velocity(left_v, right_v)
end

-- Advance logic for random walking, this function generates a number of steps for walking and an angle where the robot has
-- to turn, then the robot goes straight for the number of generated steps.
function move_r.walk_randomly(robot)
	if steps <= 0 then
		local angle = math.random(0, 1)
		steps = math.random(1, 20)
		move_r.turn(robot, angle)
	else
		steps = steps - 1
		move_r.go_straight(robot)	
	end
end

-- this function allows the robot to go on a straigth line using a random velocity each time
function move_r.go_straight(robot)
	local velocity = robot.random.uniform(2, 15)
	move_r.set_velocity(robot, velocity, velocity)
end

-- this function allows the robot to turn left or right. If the angle is 1 then the robot goes right otherwise left
function move_r.turn(robot, angle)
	if angle == 1 then
		move_r.set_velocity(robot, general.MAX_VELOCITY, -general.MAX_VELOCITY)
	else
		move_r.set_velocity(robot, -general.MAX_VELOCITY, general.MAX_VELOCITY)
	end
end

-- this function set the left and right velocities of the robot's wheels.
function move_r.set_velocity(robot, left, right)
	robot.wheels.set_velocity(left, right)
end

return move_r 