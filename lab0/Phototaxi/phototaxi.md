# Phototaxi Task
The main goal of this task was to develop a robot's behaviour, capable of guiding the robot towards a source of light that it positioned inside the arena. There are no requirements about how fast the robot has to go and what happens if the robot does not detect any light at all. Also there are no requirements in what the robot has to do when it reaches the source of light.
# Design
To effectively achieve the task goal, the phototaxis behavior was implemented across two separate files. The first file, photo_logic.lua, contains the full logic required to guide the robot toward a light source. Additionally, a random walk behavior was implemented in a separate file, move_random_logic.lua. This design decision addresses a key edge case: What happens if the robot does not detect any light? Without an alternative behavior, the robot would remain stationary. To prevent this, the random walk is triggered only when no light is detected and there are no nearby obstacles, allowing the robot to continue exploring the environment until a light source becomes visible.

![Phototaxi](./images/Pt.png)

## PhotoTaxi
The phototaxi task, required the ability from the robot for detecting light in the arena. fortunately the robot is equipped with 24 light sensors, where each of them returns two different values:

1. *angle*: the angle of the sensor in radian
2. *value*: the amount of light that the sensor has detected, it is important to say that the range of value is [0, 1].

In order to use the light information from the sensors and guide the robot towards the source of light, all the sensors were divided into 4 different groups, where each group has exactly 6 different sensors:

```lua
DIRECTIONS = {
	{ direction = direction_module.NORTH, sensors = { 3, 2, 1, 24, 23, 22 } },
	{ direction = direction_module.EAST, sensors = { 21, 20, 19, 18, 17, 16 } },
	{ direction = direction_module.SOUTH, sensors = { 15, 14, 13, 12, 11, 10 } },
	{ direction = direction_module.WEST, sensors = { 9, 8, 7, 6, 5, 4 } },
}
```
The the logic for searching where is the *maximum* amount of light among all this *group* was achieve by a function that takes in input the sensor's indexs and calculate the sum of all the light values. Then the *direction* with the maximum value will be used to guide the robot towards the source of light.

```lua
function detect_light_angle(robot)
	local brightest_value = 0.0
	local max_local_value = 0
	local direction = direction_module.VOID
	for i = 1, #DIRECTIONS do
		local pair = DIRECTIONS[i]
		local intensity, max_light = detect_light_intensity(robot, pair.sensors)
		if intensity >= brightest_value then
			brightest_value = intensity
			direction = pair.direction
			max_local_value = max_light
		end
	end
	DIRECTION = direction
	return max_local_value
end

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
```

Then given the direction of the source of light, it is possible to reach the source of light by setting the appropriate velocity in both of the wheels.

```lua
function move_robot(robot)
	local factor = 2
    -- ....
	if DIRECTION == direction_module.NORTH then
		robot.wheels.set_velocity(general_module.CURRENT_VELOCITY, general_module.CURRENT_VELOCITY)
	elseif DIRECTION == direction_module.SOUTH then
		robot.wheels.set_velocity(general_module.CURRENT_VELOCITY, -general_module.CURRENT_VELOCITY)
	elseif DIRECTION == direction_module.WEST then
		robot.wheels.set_velocity(0, general_module.CURRENT_VELOCITY)
	else
		robot.wheels.set_velocity(general_module.CURRENT_VELOCITY, 0)
	end
end
```

# Random Walk
As outlined in the design, it is essential to include a behavior that enables the robot to move even when no light is detected. To achieve this, a random walk logic is activated only in the absence of light. This behavior is implemented using the footbot.random module, which provides a uniform method to generate two random values. These values are then assigned to the left and right wheel velocities, allowing the robot to explore the environment in an undirected manner when no stimuli are present.
```lua
function moverandommodule.move(robot)
	local left_v = robot.random.uniform(0, generalmodule.MAX_VELOCITY)
	local right_v = robot.random.uniform(0, generalmodule.MAX_VELOCITY)
	robot.wheels.set_velocity(left_v, right_v)
end
```
By doing this, it is possible to generate a very basic random walk that can possibly help the robot in finding the light, when it is not able to find any light at all.

