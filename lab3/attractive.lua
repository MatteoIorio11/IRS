local ps = require("sensor_schema")
local attractive = {}

local THR = 0.70
local slow_force = 1
local high_force = 4

function attractive.get_vector(robot)
	return ps.from_sensors(robot.light, 1, 0.0, attractive.module_force)
end


function attractive.module_force(distance)
	if (distance >= THR) then
		return slow_force
	end
	return distance + high_force
end

return attractive