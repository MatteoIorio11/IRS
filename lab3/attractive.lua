local ps = require("sensor_schema")
local attractive = {}

function attractive.get_vector(robot)
	return ps.from_sensors(robot.light, 1, 0.0, attractive.module_force)
end


function attractive.module_force(distance)
	if (distance >= 0.70) then
		return 1
	end
	return distance + 4
end

return attractive