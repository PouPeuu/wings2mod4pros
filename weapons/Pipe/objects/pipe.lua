image = "pipe"
condition = 9.0
bounding_circle_radius = 2
hit_damage = 0
hit_impulse = 0
touch_damage = 0
mass = 20.0
volume = 0.2
air_resistance = 100

function init(x_pos, y_pos, x_vel, y_vel, owner_id)
	px, py = get_object_pos(owner_id)
	vx, vy = get_object_vel(owner_id)
	px, py = find_last_clear_point(px, py, px+x_pos, py+y_pos)
	set_pos(px, py)
	set_vel(vx+x_vel, vy+y_vel)
	set_owner(owner_id)
end

function on_hit_object(id)
	if get_object_type(id) == "pipe_node" then
		--call_object(id)
 		send_game_message("hit object lmao")
		attach_to(id)
	end
end

function on_call(id)
	call_object(id,get_id(),get_attached_object())
end