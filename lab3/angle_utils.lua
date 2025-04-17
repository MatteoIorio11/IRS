local angle_utils = {}

-- Normalise the input angle in the range [0, 2pi]
function angle_utils.normalise(angle)
        if angle > math.pi then
                angle = angle - (2 * math.pi)
	elseif angle < -math.pi then
                angle = angle + (2 * math.pi)
	end
        return angle
end

-- Get the opposite of the input angle
function angle_utils.opposite(angle)
	local opposite_angle = angle - math.pi
        return angle_utils.normalise(opposite_angle) -- add safety
end

-- Generate a random angle in the range [0, 2pi]
function angle_utils.generate_random_angle()
        return  angle_utils.normalise(math.random(0, 360) * (math.pi / 180))
end

return angle_utils