local ground = {}

---comment Read the lowest color tonality detected. If 0 then is black otherwise is white.
---@param robot any
---@return integer color this function returns the color with the lowest tonality.
function ground.detect_ground_color(robot)
	local sensors = robot.motor_ground
	local color = math.huge
	for i = 1, #sensors do
		local ground_color = sensors[i].value
		color = math.min(ground_color, color)
	end
	return color
end

return ground

