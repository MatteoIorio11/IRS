local photo_logic = require("photo_logic")
local move_random_logic = require("move_random_logic")

-- Layer structure:
-- Priority 0: move random logic
-- Priority 1: photo taxi logic
-- Priotity 2: halt logic (stop when ground is black)
-- Priority 3: avoid obstacle


function init() end

--[[ This function is executed at each time step
     It must contain the logic of your controller ]]
function step()
	if photo_logic.sense(robot) then
		photo_logic.callback(robot)
	else
		move_random_logic.callback(robot)
	end
end

function reset() end

function destroy() end
