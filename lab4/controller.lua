local avoid_logic = require("avoid_logic")
local signal = require("signal")
local probability = require("probability")
local walk = require("random_walk")
local states = require("states")

local currrent_state = states.WALKING
local TOTAL_ROBOTS = 30
local TICK = 1
local current = 0

function init() end

--[[ This function is executed at each time step
     It must contain the logic of your controller ]]
function step()
    if current % TICK == 0 then
        if currrent_state == states.STOPPED then
            local total_stopped = signal.count_stopped(robot)
            local should_walk = probability.should_walk(TOTAL_ROBOTS, 0.01, 0.1, total_stopped)
            if should_walk then
                handle_walk()
            end
        elseif currrent_state == states.WALKING then
            local total_stopped = signal.count_stopped(robot)
            local should_stop = probability.should_stop(TOTAL_ROBOTS, 0.1, 0.05, total_stopped)
            if should_stop then
                handle_stop()
            else
                if avoid_logic.sense(robot) then
                    avoid_logic.callback(robot)
                else
                    walk.move(robot)
                end
            end
        end
        current = 0
    end
    current = current + 1
end

function handle_stop()
    currrent_state = 1
    signal.stop_moving(robot)
    robot.leds.set_all_colors("green")
    robot.wheels.set_velocity(0, 0)
end

function handle_walk()
    currrent_state = 2
    signal.start_moving(robot)
    robot.leds.set_all_colors("black")
end

function reset() end

function destroy() end