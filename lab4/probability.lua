local probability = {}
local signal = require("signal")
local ground = require("ground")

local PS_max = 0.99
local PW_min = 0.005

function probability.should_stop(robot, S, alpha)
    local total_stopped = signal.count_stopped(robot)
    return probability.apply(math.min(PS_max, (S + alpha * total_stopped)))
end

function probability.should_walk(robot, W, beta)
    local total_stopped = signal.count_stopped(robot)
    return probability.apply(math.max(PW_min, (W - beta * total_stopped)))
end

function probability.should_walk_with_spot(robot, W, beta)
    local total_stopped = signal.count_stopped(robot)
    local color = ground.detect_ground_color(robot)
    return probability.apply(math.max(PW_min, (W - beta * total_stopped) + color))
end

function probability.should_stop_with_spot(robot, S, alpha)
    local total_stopped = signal.count_stopped(robot)
    local color = ground.detect_ground_color(robot)
    return probability.apply(math.min(PS_max, (S + alpha * total_stopped) - color))
end

function probability.apply(prob)
    local t = robot.random.uniform()
    return t <= prob
end

return probability