local random = {}

local last_angle = 0

function random.get_vector(robot, light_angle)
    local angle = 0
    log("ciao")
    log(light_angle)
    if not (light_angle == 0.0) or not (last_angle == 0.0) then
        if not (light_angle == 0.0) then
            last_angle = light_angle
        end
        angle = last_angle
    else
        angle = random.normalise(math.random(0, 360) * (math.pi / 180))
    end
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