local color = {}

---comment Set the robot's led color to red
---@param robot any
function color.go_red(robot)
	robot.leds.set_all_colors("red")
end

---comment Set the robot's led color to green
---@param robot any
function color.go_green(robot)
	robot.leds.set_all_colors("green")
end

---comment Set the robot's led color to black
---@param robot any
function color.go_black(robot)
	robot.leds.set_all_colors("black")
end

return color

