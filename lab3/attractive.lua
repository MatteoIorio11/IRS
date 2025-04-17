local ps = require("sensor_schema")
local random = require("random_vector")
local vector = require("vector")
local attractive = {}

local THR = 0.70
local slow_force = 1
local high_force = 4

-- Get the vector from all the attractive forces. In this case the attractive force is the 'phototaxi' and 'random walk' behaviour.
function attractive.get_vector(robot)
	local phototaxi_vector = ps.from_sensors(robot.light, 1, 0.0, attractive.module_force) -- phototaxi
	local random_vector = random.generate_random_vector() -- random walk
	return vector.vec2_polar_sum(phototaxi_vector, random_vector)
end

-- Module the force that the robot feels using the input distance.
function attractive.module_force(distance)
	if (distance >= THR) then
		return slow_force
	end
	return distance + high_force
end

return attractive