local signal = {}

local CHANNEL = 1
local STOP = 1
local WALKING = 0 
local MAX_RANGE = 30

-- this function signals the other robots the fact that 'this' has started to walk.
function signal.start_moving(robot)
    robot.range_and_bearing.set_data(CHANNEL,WALKING)
end

-- this function signals the other robots the fact that 'this' has stopped.
function signal.stop_moving(robot)
    robot.range_and_bearing.set_data(CHANNEL,STOP)
end

-- this function counts the number of robot that are curretly stopped.
function signal.count_stopped(robot)
    return signal.count_status(robot, STOPPED)
end

-- this function counts the number of robot that are currently walking.
function signal.count_walking(robot).
    return signal.count_status(robot, WALKING)
end

-- this function counts the number of robot that are in a given status.
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