--#region Avoid Object Module
-- Here is implemented the logic for automatically avoid an object

local direction_module = require("directions")
local general_module = require("general")

local avoid_module = {}
OBJECT_THRESHOLD = 0.15
ANGLE = 0

-- Sense all the proximity sensors, check if the robot should avoid an object.
function avoid_module.sense(robot)
	return avoid_object_step(robot) == direction_module.DETECTED
end

-- Callback of the module, It means that the robot previously has detected an object and It needs to avoid it.
function avoid_module.callback(robot)
	log("robot: Priority over avoid object task")
	robot.leds.set_all_colors("red")
	avoid_object(robot, ANGLE)
end

---comment Logic for avoiding an object using the proximity sensors
---@return integer state of the robot, if an object is detected this function returns DETECTED otherwise SAFE
function avoid_object_step(robot)
	local nearest_object = find_nearest_object(robot)
	-- NOTE: If the detected object is close (by confronting the distance with the THR), then we try to avoid the object.
	if nearest_object >= OBJECT_THRESHOLD then
		return direction_module.DETECTED
	else
		robot.leds.set_all_colors("black")
		return direction_module.SAFE
	end
end

-- #NOTE: the proximity sensor returns a value in [0, 1] if the detected value is close to 1 then the distance from the object is very close.
--- comment: Find the nearest object around the robot. This function returns the nearest distance and the sensor's angle.
---@return number the distance from the nearest object
function find_nearest_object(robot)
	local nearest_object = 0.0 -- nearest distance from the closest object
	local proximity_angle = 0.0 -- sensor's angle

	for i = 1, #robot.proximity do
		local object_distance = robot.proximity[i].value
		if object_distance > nearest_object then
			nearest_object = object_distance
			proximity_angle = robot.proximity[i].angle
		end
	end
	ANGLE = proximity_angle
	return nearest_object
end

--#NOTE: The input object position is in Radiant.
---comment: This method is used for avoiding the detected object, by using the input angle from which the object was detected.
function avoid_object(robot, angle)
	if angle > 0 then
		robot.wheels.set_velocity(general_module.MAX_VELOCITY, 0)
	else
		robot.wheels.set_velocity(0, general_module.MAX_VELOCITY)
	end
end

return avoid_module
