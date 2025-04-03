# Collision Avoidance Task
This task required the goal of *random walking* while *avoding* the obstacles that were present in the arena. The robot does not have a specific task to do, so It has not a final destination to reach, It just
wants to walk freely in the arena and in the meantime avoid all the obstacles that are present along Its journey.
# Design
In order to achieve the desired goal of the task, I have divided the two logics into two different and separated files:
1. *move_random_logic*: inside this file I have developed the entire logic for the *random walking*;
2. *avoid_logic*: the content of this file represent the logic for *avoiding* the different obstacles that are present in the arena.

The robot always checks if it is possible to randomly walk, because if the *footbot* detects an obstacle, the first thing that It will try to do will be to avoid It with a logic that will be further described.
So, in case there are no obstacles in front or around the robot, then the random walk can be executed without worrying about colliding with an obstacle.

## Random walk
For what concernes the random walking of the robot, I wanted to use a simple logic for the generation of this *behaviour*. So in order to stay as as simple as possible and in the meantime achieve the goal of *random walking*, I have used the *footbot random module*. More precisely, I have used the *uniform* method for automatically generate two different values inside the interval [0, 15]. Then both of this two values, where set as the velocities for the two wheels.

```lua
function moverandommodule.move(robot)
	log("robot: Priority over move random task")
	local left_v = robot.random.uniform(0, generalmodule.MAX_VELOCITY)
	local right_v = robot.random.uniform(0, generalmodule.MAX_VELOCITY)
	robot.wheels.set_velocity(left_v, right_v)
end
```


# Implementation
Come stato implementato

