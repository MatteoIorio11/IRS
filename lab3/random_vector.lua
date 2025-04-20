local angle_utils = require("angle_utils")
local random = {}

-- Generate a random vector.
function random.generate_random_vector(robot)
    local angle = angle_utils.generate_random_angle() -- get the angle
    local vector = {angle=angle, length=math.random(0.0, 4.0)} -- get the length
    return vector
end

return random