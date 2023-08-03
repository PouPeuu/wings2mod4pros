image = "car"
condition = 100
bounding_circle_radius = 10
hit_damage = 0
hit_impulse = 0
mass = 100
volume = 10
air_resistance = 1.0

ground_kills = false





function magnitude(x, y)
	return math.sqrt(x^2+y^2)
end

function init(x, y, x_vel, y_vel, owner_id)
	set_owner(owner_id)
	px, py = get_object_pos(owner_id)
    vx, vy = get_object_vel(owner_id)
    
    team = get_object_team(owner_id)
    set_team(team)

    set_pos(px+x, py+y)
    set_vel(x_vel,y_vel)

	--[[x, y = get_pos()
	set_object_pos(wheel1, x+11, y+4)
	set_object_pos(wheel2, x-12, y+4)

	w1x, w1y = get_object_pos(wheel1)
	w2x, w2y = get_object_pos(wheel2)
	wheelDistance = distance(w1x, w1y, w2x, w2y)]]
end

function run_simulation()
	--set_object_pos(wheel1, x+11, y+4)
	--set_object_pos(wheel2, x-12, y+4)

	--[[w1x, w1y = get_object_pos(wheel1)
	w2x, w2y = get_object_pos(wheel2)

	dist = distance(w1x, w1y, w2x, w2y)

	vecX = w1x - w2x
	vecY = w1y - w2y

	normalizedVecX = vecX / dist
	normalizedVecY = vecY / dist

	if dist>wheelDistance then
		set_object_pos(wheel2, w2x+normalizedVecX, w2y+normalizedVecY)
	end

	if dist<wheelDistance then
		set_object_pos(wheel2, w2x-normalizedVecX, w2y-normalizedVecY)
	end

	dir = get_vector_dir(w1x-w2x, w1y-w2y)-90
	set_dir(dir)

	set_pos((w1x+w2x)/2, (w1y+w2y)/2)]]
end