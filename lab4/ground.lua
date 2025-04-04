local ground = {}

function ground.detect_ground_color(robot)
    local sensors = robot.base_ground
    local color = 1
    for i=1, #sensors do
        local ground_color = sensors[i]
        color = math.min(ground_color, color)
    end
    return color == 0 or color <= 10e-2
end

return ground