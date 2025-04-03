local attractive = require("attractive")
local repulsive = require("repulsive")
local random = require("random_force")
local motor = require("motor_schema")
local vector = require("vector")

function init() end

--[[ This function is executed at each time step
     It must contain the logic of your controller ]]
function step()
	local v1 = attractive.get_vector(robot)
	local v2 = repulsive.get_vector(robot)
	local v3 = random.get_vector(robot)
	motor.move(robot, vector.vec2_polar_sum(v1, vector.vec2_polar_sum(v2, v3)))
end

function reset() end

function destroy() end
