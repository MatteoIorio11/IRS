local angle_utils = require("angle_utils")
local random = {}


function random.get_vector(robot)
    local angle = angle_utils.normalise(math.random(0, 360) * (math.pi / 180))
    local vector = {angle=angle, length=math.random(0.0, 1.0)}
    return vector
end

return random