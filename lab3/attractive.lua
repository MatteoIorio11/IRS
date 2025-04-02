local ps = require("sensor_schema")
local attractive = {}

function attractive.get_vector(robot)
	-- return ps.from_sensor_groups(robot.light, attractive.module_force)
	log("Attractive")
	return ps.from_sensors(robot.light, 1, 0.0, attractive.module_force)
end


function attractive.module_force(distance)
	log("Force: " .. distance)
	if (distance >= 0.70) then
		return 1
	end
	log("OTTO")
	return distance + 4
end

return attractive