local avoid_logic = require("avoid_logic")
local phototaxi = require("photo_logic")
local move_random_logic = require("move_random_logic")

function init() end

--[[ This function is executed at each time step
     It must contain the logic of your controller ]]
function step()
	if avoid_logic.sense(robot) then
		avoid_logic.callback(robot)
	elseif phototaxi.sense(robot) then
		phototaxi.callback(robot)
	else
		move_random_logic.callback(robot)
	end
end

function reset() end

function destroy() end
