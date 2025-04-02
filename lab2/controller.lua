local photo_logic = require("photo_logic")
local avoid_logic = require("avoid_logic")
local move_random_logic = require("move_random_logic")
local halt_logic = require("halt_logic")

-- Layer structure:
-- Priority 0: move random logic
-- Priority 1: photo taxi logic
-- Priotity 2: halt logic (stop when ground is black)
-- Priority 3: avoid obstacle

STACK = {
	move_random_logic,
	photo_logic,
	halt_logic,
	avoid_logic,
}

function init() end

--[[ This function is executed at each time step
     It must contain the logic of your controller ]]
function step()
	local override = false
	for i = #STACK, 1, -1 do
		local module = STACK[i]
		if module.sense(robot) == true then
			module.callback(robot)
			override = true
			break
		end
	end
	if not override then
		log("Moving randomm")
		STACK[1].callback(robot)
	end
end

function reset() end

function destroy() end
