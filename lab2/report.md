# Subsumption Architecture
The robot is expected to be able to find a light source and go towards it, while avoiding collisions with other objects, such as walls, boxes and other robots. The robot should reach the target as fast as possible and, once reached it, it should halt. A black spot underneath the light bulb identifies the halt region. It is important to say that there is nothing about what should happen where there is not light at all and no objects around the robot.

## Design
The overall design of the system is based on the *layered architecture*, in which every single behaviour is implemented inside its own lua file:
1. *avoid_logic*: contains the real logic for avoiding the obstacles;
2. *halt_logic*: contains the logic for stopping the robot when it is on a black spot;
3. *photo_logic*: contains the logic for going towards the source of the light;
4. *move_random_logic*: contains the logic for activate the random walk of the robot.

The design of all the different tasks use an Object Oriented philosophy, where every logic file exposes two main different *APIs*:
1. *sense*: with the using of this method the behaviour's logic searches in the environment and decides if it has something to do (for example avoid an obstacle, going towards the light), this method returns *True* if it is necessary to call its *callback* otherwise it will return *False*.
2. *callback*: the second API, runs the *real logic* for a specific task, this must be run only if the *sense* method has returned True.

Because one of the requirements of this task was to develop the robot behaviour using the *subsumption architecture*, it was necessary to define all the different priorities over all the different tasks. Among all the possible combinations of behaviours, the chosen stack was this one:
1. Avoid Obstacle;
2. Halt Logic;
3. PhotoTaxi Logic;
4. Random Walk Logic.

In order to execute all the behaviours using the correct order of priority, inside the controller it is used a *decreasing monotonic* stack, where on top of the stack there is the logic with the *highest priority*.

![stack structure](./images/monotonic_stack.png)

As can be seen from the image, every time that the *sense* method returns false, the controller automatically checks a behaviour with a lower priority. When the *sense* method returns true, the *callback* method is invoked, then its main logic will be executed and then the execution of the exploration of the stack will be *interrupted* by using a *break*, in this way the robot is always able to run the most important task when needed. This allows the robot to always choose the best behaviour to use in order to overcome the *sensed* problem.

```lua
local photo_logic = require("photo_logic")
local avoid_logic = require("avoid_logic")
local move_random_logic = require("move_random_logic")
local halt_logic = require("halt_logic")

STACK = {
	move_random_logic, -- Priority 0
	photo_logic, -- Priority 1
	halt_logic, -- Priority 2
	avoid_logic, -- Priority 3
}
```

### Step Analysis
Each time the step method is called within the controller, the thread traverses the stack from top to bottom—that is, from the highest to the lowest priority. For each logic in the stack, the controller invokes the *sense* API. If sense returns true, the corresponding callback method is executed. This ensures that the robot performs the *highest-priority logic* available at that moment, after which the loop is terminated. If none of the logics are triggered, the robot defaults to executing a random walk.

```lua
function step()
	local override = false
	for i = #STACK, 1, -1 do
		local module = STACK[i]
		if module.sense(robot) then
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

To be noticed, the random walk sense method always returns *true*, this is because it does not need specific conditions to run. Also if none of the behaviour has ran, the controller automatically ran the behaviours with the lowest priority.

### Avoid Obstacle
The first behavior implemented and monitored by the controller is the *Avoid Obstacle* logic. This behavior enables the robot to prevent potential *collisions* with generic obstacles within the arena. Like all other behaviors in the system, the *Avoid Obstacle* behavior consists of two core methods: *sense* and *callback*.
#### Sense
The Avoid Obstacle's sense method, has the main goal to check if the robot has to avoid a possible obstacle that is near him, more in particular this method will check all 24 proximity sensors and if one of the detected value is higher that a specific *threshold*, it means that the robot is in a critic conditions and it has to immediately take action for avoid the obstacle, this means that the controller must call the *callback* method.

```lua
function avoid_module.sense(robot)
	return avoid_object_step(robot) == direction_module.DETECTED
end

function avoid_object_step(robot)
	local nearest_object = find_nearest_object(robot)
	if nearest_object >= OBJECT_THRESHOLD then
		return direction_module.DETECTED
	else
		robot.leds.set_all_colors("black")
		return direction_module.SAFE
	end
end
```

#### Callback
The *callback* method of the *Avoid Obstacle* behavior is responsible for executing the actions needed to avoid a detected obstacle. As shown in the previous code related to the sense method, this method triggers the *avoid_object_step* function, which in turn utilizes the *find_nearest_object* function. The purpose of *find_nearest_object* is to identify the closest obstacle. In addition to this, it stores the angle of the proximity sensor with the highest reading in a global variable called *ANGLE*. This angle represents the direction of the most immediate threat. If the distance between the obstacle and the robot exceeds a certain threshold, the robot will use this stored angle to determine the best direction to turn—specifically, it will rotate in the opposite direction of the detected obstacle in order to avoid it effectively.

```lua
function avoid_module.callback(robot)
	robot.leds.set_all_colors("red")
	avoid_object(robot, ANGLE) -- the angle is taken from the internal logic
end

function avoid_object(robot, angle)
	-- turns the robot is the opposite direction
	if angle > 0 then
		robot.wheels.set_velocity(general_module.MAX_VELOCITY, 0)
	else
		robot.wheels.set_velocity(0, general_module.MAX_VELOCITY)
	end
end
```

### Halt
The first behavior implemented and monitored by the controller is the *Avoid Obstacle* logic. This behavior enables the robot to prevent potential *collisions* with generic obstacles within the arena. Like all other behaviors in the system, the *Avoid Obstacle* behavior consists of two core methods: *sense* and *callback*.

The second behaviour that is implemented and also executed by the controller is the *halt* logic. This is the behaviour that allows the robot to stop if it is over black spot. As every other logic, it implements two core methods: *sense* and *callback*.
#### Sense
The Halt's sense method is designed to check if the *ground* under the robot is completely *black*.
```lua
function halt_module.sense(robot)
	return check_ground(robot)
end
```
The `check_ground` function checks the value of every single motor ground sensor, and if one of them spots the colour black, the sensor method will return true otherwise false. In this way the controller will always be informed about the possibility of calling the Halt's callback.

#### Callback
The *callback* method of the Halt behaviour is in charge of stopping the robot, by setting the left and the right velocity to zero.

```lua
function halt_module.callback(robot)
	general_module.CURRENT_VELOCITY = 0
	robot.wheels.set_velocity(general_module.CURRENT_VELOCITY, general_module.CURRENT_VELOCITY)
end
```
### Phototaxi
The third behaviour that is executed by the controller is regarding the *photaxi* task. This behaviour, guides the robot towards a source of light inside the arena. This logic exposes two core apis: *sense* and *callback*.
#### Sense
The first core method that is invoked by the controller is *sense*. This method is in charge of detecting the position of the source of light that is inside the arena. In order to detect any light in the arena, the robot uses the *light sensors*. The robot is equipped with 24 different sensors, organized in 4 different groups with 6 sensors each. The arranged layout can be seen from the image ##AGGIUNGIIIII IMMAGINEEEE. The sense method checks each light sensor and if one of the has a value that is greather that a given threshold it will be necessary to make the robot walk towards the source of the light.
```lua
function photo_module.sense(robot)
	LIGHT = detect_light_angle(robot) -- get the angle and the amount of light detected from sensors.
	return not (DIRECTION == direction_module.VOID) -- the Direction is set inside the detect_light_angle function
end
```

#### Callback
The second core method is the *callback*. The logic implemented inside it helps the robot to walk towards the source of the light. This function is designed to use the direction of the group for turning the robot and make it go directly towards the light.
```lua
function photo_module.callback(robot)
	log("robot: Priority over photo task")
	move_robot(robot)
end

function move_robot(robot)
	-- ...
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
### Random Walk
The last 
#### Sense
#### Callback

### Observations: Behavioural Tree
This layered architecture really resemble a *behavioural tree*, because the controller executes the real behaviour of a node only when its status is true (in this case it means that the node has to do something), then the controller execute the code inside the node (by calling the *callback* method) and it will return. Instead if the *sense* method, which contains the *activation condition*, returns false the *controller* will step on the next most important behaviour to check and possibly execute it. By using this type of architecture I have noticed that the code is really well separated, and the fact of splitting the activation condition and the execution code in two different methods linked to a single behaviour really helps in to creating long chains of more complex mechanism in which a signle behaviour can be composed by multiple simple behaviours and so on (by following the *Divide et Conquer* method).

![behavioural tree](./images/bt.png)