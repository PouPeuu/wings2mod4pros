image = "rooperSpawner_drop"
condition = 25.0
bounding_circle_radius = 6
mass = 100.0
volume = 1
air_resistance = 2000.0

function init(x_pos, y_pos, x_vel, y_vel, owner_id)
  px, py = get_object_pos(owner_id)
  vx, vy = get_object_vel(owner_id)
  px, py = find_last_clear_point(px, py, px+x_pos, py+y_pos)
  set_pos(px, py)
  set_vel(vx+x_vel, vy+y_vel)
  set_owner(owner_id)
end

function on_hit_ground(cx, cy)
  px, py = get_pos()
  px, py = find_last_clear_point(cx, cy, px, py)
  create_object("rooperSpawner_build", px, py, get_id())
  kill()
end

