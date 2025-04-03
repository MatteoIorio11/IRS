local random = {}

local last_angle = 0

function random.get_vector(robot)
    local angle = random.normalise(math.random(0, 360) * (math.pi / 180))
    local vector = {angle=angle, length=math.random(0.0, 1.0)}
    return vector
end




function random.normalise(angle)
	if angle > math.pi then
        angle = angle - (2 * math.pi)
	elseif angle < -math.pi then
        angle = angle + (2 * math.pi)
	end
    return angle
end

return random