local perception = {}

DIRECTIONS = {
	{ sensors = { 3, 2, 1, 24, 23, 22 } }, -- front angle=0
	{ sensors = { 21, 20, 19, 18, 17, 16 } }, -- right angle = -pi/2
	{ sensors = { 15, 14, 13, 12, 11, 10 } }, -- behind pi
	{ sensors = { 9, 8, 7, 6, 5, 4 } }, -- pi / 2
}

function perception.from_sensor_groups(sensors, force)
    local max_val = 0
    local max_angle = 0
    for i=1, #DIRECTIONS do
        local info = DIRECTIONS[i]
        local result, angle = get_max_from_group(sensors, info.sensors)
        if result > max_val then
            max_val = result
            max_angle = angle
        end
    end
	return {angle=max_angle, length=max_val }
end

function get_max_from_group(sensors, indexs)
	local intensity = 0
    local angle = 0
    local highest_value = 0
	for i = 1, #indexs do
		local sensor = indexs[i]
		local light_value = (sensors[sensor].value)
        if light_value > highest_value then
            highest_value = light_value
            angle = sensors[sensor].angle
        end
		intensity = intensity + light_value
	end
	return intensity, angle
end

function perception.from_sensors(sensors, MAX_VALUE, thr, force)
    local best_angle = 0
    local max_value = 0.0
    for i=1, #sensors do
        local sensor = sensors[i]
        if sensor.value >= thr and max_value < sensor.value then
            max_value = sensor.value
            best_angle = sensor.angle
        end
    end
    local length = max_value + (max_value + force(max_value))-- ((MAX_VALUE - max_value) / MAX_VALUE) * force(max_value)
    return {angle=best_angle, length=length}
end

return perception
