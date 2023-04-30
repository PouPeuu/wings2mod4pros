image = "rocket"
condition = 12.0
bounding_circle_radius = 3
hit_damage = 5
hit_impulse = 70
touch_damage = 0
thrust = 20000.0
mass = 50.0
volume = 0.5
air_resistance = 1000.0
has_dir = true
static_dir = true
network_updates = true


function init(x_pos, y_pos, x_vel, y_vel, dir, owner_id)
  px, py = get_object_shoot_pos(owner_id)
  vx, vy = get_object_vel(owner_id)
  px, py = find_last_clear_point(px, py, px+x_pos, py+y_pos)
  set_pos(px, py)
  set_vel(vx+x_vel, vy+y_vel)
  set_dir(dir)
  set_owner(owner_id)
  set_effect("smoke_trail", true)
end

function network_init()
  set_effect("smoke_trail", true)
end

function explode()
  create_object("explosion2", 0, 0, 0, 0)
  kill()
end

function on_hit_ground(cx, cy)
  set_pos(cx, cy)
  explode()
end

function on_hit_water(cx, cy)
  set_thrust(0)
  set_effect("smoke_trail", false)
  network_update(1)
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
