animation = "turret"
hit_animation = "turret_hit"
mass = 100.0
volume = 1
air_resistance = 1500.0
has_dir = true
network_updates = true
bounding_circle_radius = 1
indestructible = true
send_reliably = true

function init(x_pos, y_pos, x_vel, y_vel, dir, owner_id)
  px, py = get_object_pos(owner_id)
  vx, vy = get_object_vel(owner_id)
  px, py = find_last_clear_point(px, py, px+x_pos, py+y_pos)
  set_dir(dir)
  set_pos(px, py)
  set_vel(vx+x_vel, vy+y_vel)
  set_owner(owner_id)
  set_team(get_object_team(owner_id))
end

function on_hit_ground(cx, cy)
  x, y = get_pos()
  cx, cy = find_last_clear_point(cx, cy, x, y)
  set_pos(cx, cy)

  attach_to_ground(1)
  network_update(2)
  stop_timer()
end

function on_timer()
  network_update(1)
  set_timer(0.1)
end


function on_call(t)
  if t == "kill" then
    kill()
  end
  if t == "free" then
    attach_to(0)
    set_timer(0.1)
    network_update(2)
  end
end



