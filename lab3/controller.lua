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
	-- local v3 = random.get_vector(robot, v1.angle)
	motor.move(robot, vector.vec2_polar_sum(v1, v2))
end

function reset() end

function destroy() end
