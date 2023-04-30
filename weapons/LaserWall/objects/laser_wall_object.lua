animation = "laser_wall_object"
condition = 20.0
bounding_circle_radius = 3
hit_damage = 0
hit_impulse = 0
touch_damage = 0
mass = 30.0
volume = 0.2
air_resistance = 250.0
ground_kills = false
send_reliably = true
network_updates = true


function init(x_pos, y_pos, x_vel, y_vel, owner_id)
  px, py = get_object_pos(owner_id)
  vx, vy = get_object_vel(owner_id)
  px, py = find_last_clear_point(px, py, px+x_pos, py+y_pos)
  set_pos(px, py)
  set_vel(vx+x_vel, vy+y_vel)
  set_owner(owner_id)
  set_timer(0.1)
  network_init()
end

function network_init()
  this.emp_effect = 0
  this.emp_effect_time = 0
end

function on_timer()

  if this.emp_effect_time > 0 then
    this.emp_effect_time = this.emp_effect_time - 0.3
    if this.emp_effect_time <= 0 then
      call_object(this.emp_effect)
      set_active(true)
    end
    set_timer(0.3)
    return
  end
  
  px, py = get_pos()
  mx, my = get_map_pos(px, py)
  support = false
  for tx = -1, 1 do
    for ty = -1, 1 do
      if not terrain.is_clear(get_map_type(mx+tx, my+ty)) then
        support = true
        break
      end
    end
  end
  if not support then
    attach_to(0)
  end
  
  fx, fy = get_force()
  if distance(0, 0, fx, fy) > 35000 then
    attach_to(0)
  end

  network_update(1)
  if attached_to_ground() then
    set_timer(0.3)
  else
    set_timer(0.1)
  end

end

function on_hit_ground(cx, cy)
  x, y = get_pos()
  cx, cy = find_last_clear_point(cx, cy, x, y)
  set_pos(cx, cy)
  attach_to_ground(1)
  network_update(2)
end

function on_call(t)
  kill()
end


function on_emp_hit(power)
  if this.emp_effect_time <= 0 then
    this.emp_effect = create_object("emp_effect", get_id())
  end
  this.emp_effect_time = power
  set_active(false)
end


