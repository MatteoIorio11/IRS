# Subsumption Architecture
The robot is expected to be able to find a light source and go towards it, while avoiding collisions with other objects, such as walls, boxes and other robots. The robot should reach the target as fast as possible and, once reached it, it should halt. A black spot underneath the light bulb identifies the halt region. Among all this requirements there is nothing about what should happen where there is not light at all and no objects around the robot.

## Design
I have developed this system using a layered architecture, in which I have separated all the different tasks into different *lua* file:
1. *avoid_logic*: contains the real logic for avoiding the obstacles;
2. *halt_logic*: contains the logic for stopping the robot when it is above a black spot;
3. *photo_logic*: contains the logic for going towards the source of the light;
4. *move_random_logic*: contains the logic for activate the random walk of the robot.

I have developed this files thinking in an Object Oriented way, where every logic file exposes two main different APIs:
1. *sense*: with the using of this method the "class" searches in the environment and decides if it has something to do (for example avoid an obstacle, going towards the light), this method returns True if it is necessary to call Its callback otherwise it will return False.
2. *callback*: the second API, runs the *real logic* for doing a specific task, this must be run only if the *sense* method has returned True.

Because one of the requirement of this task was to develop the robot behaviour using the subsumptio architecture, it was necessary to define all the different priorities over all the different tasks, the order that I have decided is this one:
1. Avoid Obstacle;
2. Halt Logic;
3. PhotoTaxi Logic;
4. Random Walk Logic.

In order to model this priority I have placed all the logic inside a decreasing monotonic stack, where on top of the stack the is the logic with the highest priority:

```lua
local photo_logic = require("photo_logic")
local avoid_logic = require("avoid_logic")
local move_random_logic = require("move_random_logic")
local halt_logic = require("halt_logic")

STACK = {
	move_random_logic, -- Priority 0
	photo_logic, -- Priority 1
	halt_logic, -- Priorityu 2
	avoid_logic, -- Priority 3
}
```

Then each time the *step* method is invoked inside the controller, we explore the stack by going from top to bottom (from the highest priority to the lowest priority) and for each of the logic we invoke the api *sense*, then if it returns true it will be called the *callback* method, in this way the robot will execute the logic of that particular task and finally we break from the loop because the logic with an highest priority has been executed and the remaining ones can not be executed. If none of the logic is ran, the robot will invoke the random walk.

```lua
function step()
	local override = false
	for i = #STACK, 1, -1 do
		local module = STACK[i]
		if module.sense(robot) == true then
			module.callback(robot)
			override = true
			break
		end
	end
	if not override then
		STACK[1].callback(robot)
	end
end
```