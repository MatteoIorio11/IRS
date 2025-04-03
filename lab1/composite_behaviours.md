# Composite Behaviours
The main goal of this task was to develop a robot's behaviour capable of avoiding all the obstacles that are present inside the arena and in the mean time reach the source of light. There are no requirements in what the robot has to do when there is no light at all.

## Design
The entire behaviour of this task, is divided into three different logics, then each logic is implemented inside a specific file, in order to have a better encapsulation:

1. *avoid_logic*: inside this file is implemented the logic for avoiding the obstacles in the arena;
2. *photo_logic*: this file contains the logic for the phototaxi task;
3. *move_random_logic*: logic for random walking in the arena.

Because this assesment has no specifics about what the robot has to do when the robot does not detect any light at all, I have decided to add the random walking logic only when the robot detects not light and in the nearby there are not obstacles to avoid. Each of this *file* exposes two different methods:

1. *sense*: search in the environment around the robot and decided if it has to do something;
2. *callback*: apply the main logic designed in the file (avoid the obstacle, go towards the light, random walk).

Inisde the controller I have designed the logic using a cascade of ifs, where starting from the most important task, the *collision avoidance*, we go down towards the *random walk*. Here is how It is implemented:

```lua
function step()
	if avoid_logic.sense(robot) then
		avoid_logic.callback(robot)
	elseif phototaxi.sense(robot) then
		phototaxi.callback(robot)
	else
		move_random_logic.callback(robot)
	end
end
```
By doing this I am able to alway perform the most *important* task every time, so in this case if there is an object the robot will always try to avoid it, then if there are no objects at all around the robot, It will search for the light and if no light is detected then the robot will start *move randomly* in the area until an obstacle is detected or better if the source of light has been detected.

### Obstacle Avoidance
In order to implement the obstacle avoidance, I have used a very simple logic, given all the 24 proximity sensors, I get the value with the highest score (it means that I get the closest sensor to an object), then I also save the angle of this sensor. By using the angle, then the robot is able to avoid the obstacle, by going towards the opposite direction.

### PhotoTaxi

### Random Walk