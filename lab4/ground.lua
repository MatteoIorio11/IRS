local ground = {}

function ground.detect_ground_color(robot)
    local sensors = robot.motor_ground
    local color = math.huge
    for i=1, #sensors do
        local ground_color = sensors[i].value
        color = math.min(ground_color, color)
    end
    return color
end

return ground