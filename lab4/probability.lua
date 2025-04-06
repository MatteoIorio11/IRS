local probability = {}
local signal = require("signal")
local ground = require("ground")

local PS_max = 0.99
local PW_min = 0.005

---comment Return the probability for the robot to stop. The formula is: Ps = min(PSmax, S + alpha * N)
function probability.should_stop(robot, S, alpha)
	local total_stopped = signal.count_stopped(robot)
	return probability.apply(math.min(PS_max, (S + alpha * total_stopped)))
end

---comment Return the probability for the robot to stop. The formula is: Pw = max(PWmin, W - beta * N)
function probability.should_walk(robot, W, beta)
	local total_stopped = signal.count_stopped(robot)
	return probability.apply(math.max(PW_min, (W - beta * total_stopped)))
end

---comment Return the probability for the robot to stop. The formula is: Pw = max(PWmin, W - beta * N + Dw)
function probability.should_walk_with_spot(robot, W, beta)
	local color = ground.detect_ground_color(robot)
	return probability.should_walk(W + color, beta)
end

---comment Return the probability for the robot to stop. The formula is: Ps = min(PSmax, S + alpha * N - Ds)
function probability.should_stop_with_spot(robot, S, alpha)
	local color = ground.detect_ground_color(robot)
	return probabilit.should_stop(S - color, alpha)
end

function probability.apply(prob)
	local t = robot.random.uniform()
	return t <= prob
end

return probability
