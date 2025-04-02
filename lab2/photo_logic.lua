--#region Photo module
-- Here is implemented the entire logic for searching for a light and move the robot towards that direction

local direction_module = require("directions")
local general_module = require("general")
local photo_module = {}

-- Threshold for starting the deceleration
LIGHT_SENSIBILITY = 3 * 10e-1
DIRECTION = direction_module.NORTH
LIGHT = 0

-- Directions
DIRECTIONS = {
	{ direction = direction_module.NORTH, sensors = { 3, 2, 1, 24, 23, 22 } },
	{ direction = direction_module.EAST, sensors = { 21, 20, 19, 18, 17, 16 } },
	{ direction = direction_module.SOUTH, sensors = { 15, 14, 13, 12, 11, 10 } },
	{ direction = direction_module.WEST, sensors = { 9, 8, 7, 6, 5, 4 } },
}

-- Sense all light sensors, check if the robot should go towards the light
function photo_module.sense(robot)
	-- #NOTE: Before looking for the light, we first check if there are none objects around the robot. If so, then we can procede into searching for the light.
	LIGHT = detect_light_angle(robot) -- get the angle and the amount of light detected from sensors.
	return not (DIRECTION == direction_module.VOID)
end

-- Phototaxi callback, move the robot towards the light
function photo_module.callback(robot)
	log("robot: Priority over photo task")
	move_robot(robot)
end

---comment Detect the direction where we have the maximum source of light.
---@return integer the amount of light detected
function detect_light_angle(robot)
	local brightest_value = 0.0
	local max_local_value = 0
	local direction = direction_module.VOID
	-- #NOTE: Because I have divided the robot's sensors into 4 groups, we have to check in which direction we have the
	--  brightest spot. In this way the robot know's the direction of the source of light.
	for i = 1, #DIRECTIONS do
		local pair = DIRECTIONS[i]
		local intensity, max_light = detect_light_intensity(robot, pair.sensors)
		if intensity >= brightest_value then
			log(pair.direction .. " valore: " .. intensity)
			brightest_value = intensity
			direction = pair.direction
			max_local_value = max_light
		end
	end
	DIRECTION = direction
	return max_local_value
end

---comment Get the total of all the light sensor values given the index of the input sensors
---@param sensors any : array of sensors index
---@return integer max intensity registered from the input sensors
---@return integer max light detected from one of the sensors
function detect_light_intensity(robot, sensors)
	local intensity = 0
	local max_intensity = 0
	for i = 1, #sensors do
		local sensor = sensors[i]
		local light_value = (robot.light[sensor].value * 10)
		intensity = intensity + light_value
		max_intensity = math.max(max_intensity, light_value)
	end
	return intensity, max_intensity
end

---comment Move the robot by using the DIRECTION and the LIGHT
function move_robot(robot)
	local factor = 2
	-- #NOTE: Set as upper bound MAX_VELOCITY, in this way we do not break the constraint.
	general_module.CURRENT_VELOCITY =
		math.min(math.max(general_module.CURRENT_VELOCITY * factor, 0), general_module.MAX_VELOCITY)
	if DIRECTION == direction_module.NORTH then
		log("Dritto")
		robot.wheels.set_velocity(general_module.CURRENT_VELOCITY, general_module.CURRENT_VELOCITY)
	elseif DIRECTION == direction_module.SOUTH then
		log("Indietro")
		robot.wheels.set_velocity(general_module.CURRENT_VELOCITY, -general_module.CURRENT_VELOCITY)
	elseif DIRECTION == direction_module.WEST then
		log("Sinistra")
		robot.wheels.set_velocity(0, general_module.CURRENT_VELOCITY)
	else
		log("Destra")
		robot.wheels.set_velocity(general_module.CURRENT_VELOCITY, 0)
	end
end

return photo_module
