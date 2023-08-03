image = "rooperSpawner"
image_y = -6
mass = 100.0
volume = 1
air_resistance = 1500.0
bounding_circle_radius = 10
ground_kills = false
condition = 1000

function init(x_pos, y_pos, owner_id)
  px, py = get_object_pos(owner_id)
  vx, vy = get_object_vel(owner_id)
  px, py = find_last_clear_point(px, py, px+x_pos, py+y_pos)
  set_pos(px, py)
  set_owner(owner_id)
  set_timer(2)
end

function on_timer()
  x, y = get_pos()
	create_object("rooper",x,y,get_id())
	set_timer(5)
end