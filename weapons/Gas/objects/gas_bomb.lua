image = "bomb"
condition = 12.0
bounding_circle_radius = 3
hit_damage = 10
hit_impulse = 100
touch_damage = 0
mass = 30.0
volume = 0.1
air_resistance = 50.0
send_reliably = true
ground_kills = false
network_updates = true

function init(x_pos, y_pos, x_vel, y_vel, owner_id)
  px, py = get_object_pos(owner_id)
  vx, vy = get_object_vel(owner_id)
  px2, py2 = find_last_clear_point(px, py, px+x_pos, py+y_pos)
  set_pos(px2, py2)
  if py2 == py then
    set_vel(vx, vy)
  else
    set_vel(vx+x_vel, vy+y_vel)
  end
  set_owner(owner_id)
  set_timer(1)
end

function on_timer()
  set_timer(1)
  network_update(1)
end

function explode()
  play_sound("gas")
  create_object("gas_burst", 0, 0, 0, 0, get_id())
  kill()
end

function on_hit_ground(cx, cy)
  px, py = get_pos()
  cx, cy = find_last_clear_point(cx, cy, px, py)
  set_pos(cx, cy)
  vx, vy = get_vel()
  speed = distance(0, 0, vx, vy)
  if speed > 25 then
    explode()
  end
  set_vel(0, 0)
end

function on_hit_object(id)
  if get_object_max_condition(id) >= 20 then
    set_vel(0, 0)
    explode()
  end
end

function on_break()
  explode()
end
