animation = "bumper"
hit_image = "bumper_hit"
loop_animation = true

air_resistance = 25
mass = 100.0
volume = 2.0

hit_damage = 0
hit_impulse = 0
touch_damage = 0

bounding_circle_radius = 12
check_hits = true
release_time = 3
remote_callbacks = true
remote_check_hits = true
send_reliably = true

max_hits = 20000

function init(x_pos, y_pos, owner_id)
  px, py = get_object_pos(owner_id)
  px, py = find_last_clear_point(px, py, px+x_pos, py+y_pos)
  set_pos(px, py)
  set_vel(0, 0)
  set_owner(owner_id)
  attach_to_ground(true)
  this.hits = 0
end

function network_init()
  this.hits = 0
end

function on_hit_ground(cx, cy)
  px, py = get_pos()
  cx, cy = find_last_clear_point(cx, cy, px, py)
  set_pos(cx, cy)
  set_vel(0, 0)
end

function on_timer()
  set_animation("bumper")
end

function on_hit_object(id)
  if get_object_type(id) == "laser" then kill() return end
  if get_object_type(id) == "emp" then return end
  if get_object_type(id) == "factory" then return end
  if get_object_type(id) == "wormhole_end" then return end
  if get_object_type(id) == "wormhole_start" then return end

  x, y = get_pos()
  ox, oy = get_object_pos(id)
  if ox == x and oy == y then oy = y - 1 end
  d = distance(x, y, ox, oy)
  tx = ox - x
  ty = oy - y
  rx = ty
  ry = -tx
  rd = rx*rx + ry*ry
  vx, vy = get_object_vel(id)
  rdv = rx * vx + ry * vy
  if rdv < 0 then
    rx = -rx
    ry = -ry
    rdv = -rdv
  end
  px = rx * rdv / rd
  py = ry * rdv / rd
  dx = px - vx
  dy = py - vy
  new_x = ox + 2 * tx / d
  new_y = oy + 2 * ty / d
  mx, my = get_map_pos(new_x, new_y)
  if not terrain.is_solid(get_map_type(mx, my)) then
    set_object_pos(id, new_x, new_y)
  end
  set_object_vel(id, vx + 2 * dx, vy + 2 * dy)
  mass = get_object_mass(id)
  if mass > 0 then
    effort = math.sqrt(mass * 4 * (dx*dx + dy*dy))
    if get_object_type(id) == "bumper" then effort = get_dt() * 5000 end
    this.hits = this.hits + effort
    if this.hits > max_hits then
      kill()
    else
      set_image("bumper_hit")
      t = effort / 3000
      if t > 0.15 then t = 0.15 end
      set_timer(t)
    end
  end
end

function on_emp_hit(power)
  kill()
end

