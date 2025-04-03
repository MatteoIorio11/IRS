# Composite Behaviours
The main goal of this task was to develop a robot's behaviour capable of avoiding all the obstacles that are present inside the arena and in the mean time reach the source of light. There are no requirements in what to do when the robot reaches the light and also what the robot has to do when there is no light at all.

## Design
The entire behaviour of this task, is divided into three different logics, then each logic is implemented inside a specific file, in order to have a better encapsulation:

1. *avoid_logic*: inside this file is implemented the logic for avoiding the obstacles in the arena;
2. *photo_logic*: this file contains the logic for the phototaxi task;
3. *move_random_logic*: logic for random walking in the arena.

Because this assesment has no specifics about what the robot has to do when the robot does not detect any light at all, I have decided to add the random walking logic only when the robot detects not light and in the nearby there are not obstacles to avoid. Each of this *file* exposes two different methods:

1. *sense*: search in the environment around the robot and decided if it has to do something;
2. *callback*: apply the main logic designed in the file (avoid the obstacle, go towards the light, random walk).

Inisde the controller I have 

## Obstacle Avoidance
-- copiare
## Phototaxi
-- copiare
## Random Walking
-- copiare
