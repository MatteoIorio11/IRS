local signal = {}
local CHANNEL = 1
local STOP = 1
local WALKING = 0 
local MAX_RANGE = 30

function signal.start_moving(robot)
    robot.range_and_bearing.set_data(CHANNEL,WALKING)
end

function signal.stop_moving(robot)
    robot.range_and_bearing.set_data(CHANNEL,STOP)
end

function signal.count_stopped(robot)
    return signal.count_status(robot, STOPPED)
end

function signal.count_walking(robot)
    return signal.count_status(robot, WALKING)
end

function signal.count_status(robot, status)
    local robots = 0
    for i=1, #robot.range_and_bearing do
        local neighbour = robot.range_and_bearing[i]
        if neighbour.range < MAX_RANGE and neighbour.data[CHANNEL] == status then
            robots = robots + 1
        end
    end
    return robots
end

return signal