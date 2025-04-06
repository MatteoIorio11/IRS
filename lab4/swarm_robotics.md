# Swarm Robotic
The goal of this exercise was to develop an *Aggregation Beheaviour*. Where a robot can be in two different states depending on specific conditions. The robot can be stopped and can starting moving by using a specific probability (Pw), and also if the robot is walking it can stops by using another probability (Ps). While the robot is walking it also has to *avoid* all the other robots nearby, and when there are not any other robots around it has to randomly walk in the arena. The probability of the robot to going from the status of *WALKING* to *STOPPED* depends on how many robots are stopped around a specifc arean from the robot, and the probability of the robot for going from *STOPPED* to *WALKING* depends on the number of robots that are currently walking around the current robot.

## Design
This excercise has a focus specifically on the *swarm robotic topic*. And I have divided the entire problem in different specifics. And all this specifics has the main goal of creating clusters of stopped robots. The first thing that I did was the creation of the Robot's State Machine:

![state machine](./images/state_machine.png)

There are two main states:
1. *Stopped*: this is the state where the robot does not move at all;
2. *Walking*: in this state the robot walks randomly inside the arena. while it tries to avoid all the other robots.

As can be seen from the image, when the robot is inside the *WALKING* state, it has to always avoid objects if detected, otherwise it randomly walk, it is important to say that every time the robot can fall in the *STOPPED* status. In order to achieve this behaviour, inside the step method the robot get the probability for possibly change the state, if the robot can change then it will the transtion into the newer state.

```lua
function step()
    if currrent_state == states.STOPPED then
        local should_walk = probability.should_walk(robot, 0.01, 0.1)
        if should_walk then
            handle_walk()
        end
    elseif currrent_state == states.WALKING then
        local should_stop = probability.should_stop(robot, 0.1, 0.05)
        if should_stop then
            handle_stop()
        else
            walking()
        end
    end
end
```

In this way the robot every time tries to change its state thanks to the probabilty, both methods *should_walk* and *should_stop* returns a boolean, in this way if the probability is true, the robot has to change its state. The transition from the *Stopped* state to the *Walking* (and viceversa) is guided by two different probabilites:
1. *PS*: is the probability used by the robot for switching from *Walking* to *Stopped*;
2. *PW*: is the probability used by the robot for switching from *Stopped* to *Walking*.

### Design Signaling
As the task said, the robot must be able to communicate with its neighbours using the *range* and *bearing* technology. If the robot stops, then it will set the bit number 1 (the *channel*) to one, otherwise it will set the bit channel to zero, this means that the robot starts walking in the arena. This signaling logic *helps* the robot at generating the probabilities for possibly change its state.

![signaling](./images/signaling.png)

The implementation of the *signaling* logic can be found in the *signal.lua*, and every method follows the same logic:
1. *count phase*: count the number of neighbours in a specific state;
2. 

### Design Probability
The probability is *driven* by the number of all the other robots in a specific state, in order to do that every time the robot *checks* for the probability it will also *count* the states of all its *neighbours* (in a given range). So in this way the robot will be able to rescale its *probability*.  Both probabilities depends on the number of the other robots in a given state, for example every time the robot tries to *stop*, it will count the number of robots around it that are currently *stop*, the higher the number and the higher the probability for the robot to stop, the same goes for the *walking* transition. For what concernes the *second exercise* the probability is also guided by the *ground color*, if the ground color is black then the robot will try more often to stop.

Every method in this file follows the same structure:
1. *count phase*: count the number of neighbours in a specific state;
2. *apply*: apply the input probability formula, then compare this value with a random generated value;
3. *ground color* (optional): get the ground color under the robot and use this value in the probability formula (this is only done in the exercise number 2).

```lua
-- Ex 1
function probability.should_stop(robot, S, alpha)
	local total_stopped = signal.count_stopped(robot)
	return probability.apply(math.min(PS_max, (S + alpha * total_stopped)))
end

-- Ex 2
function probability.should_stop_with_spot(robot, S, alpha)
	local color = ground.detect_ground_color(robot)
	return probabilit.should_stop(S - color, alpha)
end

function probability.apply(prob)
	local t = robot.random.uniform()
	return t <= prob
end
```



### Design Transition from States

-- Segnalazione dello stato corrente
-- Possibile passaggio da uno stato all'altro 