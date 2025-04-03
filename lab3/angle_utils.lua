local angle_utils = {}

function angle_utils.normalise(angle)
        if angle > math.pi then
                angle = angle - (2 * math.pi)
	elseif angle < -math.pi then
                angle = angle + (2 * math.pi)
	end
        return angle
end

function angle_utils.opposite(angle)
	local opposite_angle = angle - math.pi
        return angle_utils.normalise(opposite_angle)
end

return angle_utils