local probability = {}
local PS_max = 0.99
local PW_min = 0.005

function probability.should_stop(S, alpha, stopped)
    return probability.apply(math.min(PS_max, (S + alpha * stopped)))
end

function probability.should_walk(W, beta, walking)
    return probability.apply(math.max(PW_min, (W - beta * walking)))
end

function probability.should_walk_with_spot(W, beta, walking, ground)
    return probability.apply(math.max(PW_min, (W - beta * walking) + ground))
end

function probability.should_stop_with_spot(S, alpha, stopped, ground)
    return probability.apply(math.min(PS_max, (S + alpha * stopped) + ground))
end

function probability.apply(prob)
    local t = robot.random.uniform()
    return t <= prob
end

return probability