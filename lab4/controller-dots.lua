local avoid_logic = require("avoid_logic")
local signal = require("signal")
local probability = require("probability")
local walk = require("random_walk")
local states = require("states")
local color = require("colors")

local currrent_state = states.WALKING

function init() end

--[[ This function is executed at each time step
     It must contain the logic of your controller ]]
function step()
    if currrent_state == states.STOPPED then
        local should_walk = probability.should_walk_with_spot(robot, 0.01, 0.1)
        if should_walk then
            handle_walk()
        end
    elseif currrent_state == states.WALKING then
        local should_stop = probability.should_stop_with_spot(robot, 0.1, 0.05)
        if should_stop then
            handle_stop()
        else
            walking()
        end
    end
end


-- walking functionality, by using this function the robot checks if there are some other robots nearby, then if it
-- detects other robot, it will avoid them, otherwise it will perform a random walk.
function walking()
    if avoid_logic.sense(robot) then
        avoid_logic.callback(robot)
    else
        walk.move(robot)
    end
end

-- this function handle all the operations the robot has to do when it comes to stop:
-- 1: signal the other robot that it will stop
-- 2: set the leds color to green
-- 3: stop the robot
function handle_stop()
    currrent_state = states.STOPPED
    signal.stop_moving(robot)
    color.go_green(robot)
    walk.set_velocity(robot, 0, 0)
end

-- this function handle all the operations the robot has to do when it comes to start walkingl:
-- 1: signal all the other robots that it will start walking
-- 2: turn off all the leds
function handle_walk()
    currrent_state = states.WALKING
    signal.start_moving(robot)
    color.go_black(robot)
end

function reset() end

function destroy() end