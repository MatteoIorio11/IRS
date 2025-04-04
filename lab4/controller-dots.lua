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

function walking()
    if avoid_logic.sense(robot) then
        avoid_logic.callback(robot)
    else
        walk.move(robot)
    end
end

function handle_stop()
    currrent_state = 1
    signal.stop_moving(robot)
    color.go_green(robot)
    robot.wheels.set_velocity(0, 0)
end

function handle_walk()
    currrent_state = 2
    signal.start_moving(robot)
    color.go_black(robot)
end

function reset() end

function destroy() end