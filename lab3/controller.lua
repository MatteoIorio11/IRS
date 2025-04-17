local attractive = require("attractive")
local repulsive = require("repulsive")
local motor = require("motor_schema")
local vector = require("vector")

function init() end

--[[ This function is executed at each time step
     It must contain the logic of your controller ]]
function step()
	local v1 = attractive.get_vector(robot) -- get the attractive force, phototaxi
	local v2 = repulsive.get_vector(robot) -- get the repulsive force, obstacle avoidance
	motor.move(robot, vector.vec2_polar_sum(v1, v2)) -- sum all vectors and use motor schema
end

function reset() end

function destroy() end
