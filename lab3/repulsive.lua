local angle_utils = require("angle_utils")
local ps = require("sensor_schema")
local repulsive = {}

local THR = 0.10
local slow_force = 1
local high_force = 4

function repulsive.get_vector(robot)
	local vector = ps.from_sensors(robot.proximity, 1, 0.1, repulsive.module_force)
	return {angle=angle_utils.opposite(vector.angle), length=vector.length}
end

function repulsive.module_force(distance)
	if (distance >= THR) then
		return high_force + distance
	end
	return slow_force
end

return repulsive
