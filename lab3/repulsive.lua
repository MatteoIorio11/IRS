local ps = require("sensor_schema")
local repulsive = {}


function repulsive.get_vector(robot)
	local vector = ps.from_sensors(robot.proximity, 1, 0.1, repulsive.module_force)
	return {angle=invert_angle(vector.angle), length=vector.length}
end

function invert_angle(angle)
	local opposite_angle = angle - math.pi
	if opposite_angle > math.pi then
	  opposite_angle = opposite_angle - (2 * math.pi)
	elseif opposite_angle < -math.pi then
	  opposite_angle = opposite_angle + (2 * math.pi)
	end
	return opposite_angle
end



function repulsive.module_force(distance)
	if (distance >= 0.10) then
		return 4 + distance
	end
	return 1
end

return repulsive
