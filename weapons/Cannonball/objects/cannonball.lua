image = "cannonball"
condition = 18.0
bounding_circle_radius = 2
hit_damage = 0
hit_impulse = 0
mass = 30.0
volume = 0.02
air_resistance = 1.0
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
  this.last_hit_obj = 0
  this.last_hit_time = 0
end

function on_hit_ground(cx, cy)
  px, py = get_pos()
  x, y = find_last_clear_point(cx, cy, px, py)
  set_pos(x, y)
  vx, vy = get_vel()
  
  speed = distance(0, 0, vx, vy)
  if speed < 40 then
    kill()
    return
  end

  if speed > 150 then
    play_sound("cb_hit")
  end

  x2, y2 = find_first_solid_point(cx, cy, px, py)
  mx, my = get_map_pos(x2, y2)
  t = get_map_type(mx, my)
  if terrain.is_normal(t) or t == terrain.Soft or t == terrain.NoFrictionNoDamage or
    t == terrain.NoFriction or t == terrain.Flammable then
    if speed > 100 then
      remove_map_pixel(mx, my)
      set_vel(vx*0.5, vy*0.5)
      network_update(1)
      return
    end
  end
  if terrain.is_sand(t) or terrain.is_mud(t) or terrain.is_snow(t) or t == terrain.Ice then
    if speed > 50 then
      remove_map_pixel(mx, my)
      set_vel(vx*0.7, vy*0.7)
      network_update(1)
      return
    end
  end

  vx2 = -vx*0.5
  vy2 = -vy*0.5

  mx, my = get_map_pos(x, y)

  if vx > 0 then
    if terrain.is_solid(get_map_type(mx+1, my)) then
      vx2 = -vx*0.5
      vy2 = vy*0.5
    end
  else
    if terrain.is_solid(get_map_type(mx-1, my)) then
      vx2 = -vx*0.5
      vy2 = vy*0.5
    end
  end
  if vy > 0 then
    if terrain.is_solid(get_map_type(mx, my+1)) then
      vx2 = vx*0.5
      vy2 = -vy*0.5
    end
  else
    if terrain.is_solid(get_map_type(mx, my-1)) then
      vx2 = vx*0.5
      vy2 = -vy*0.5
    end
  end

  set_vel(vx2, vy2)
  network_update(1)
end

function on_hit_object(id)
  if get_object_max_condition(id) >= 20 then
    if this.last_hit_obj ~= id or this.last_hit_time+0.5 < get_time() then
      this.last_hit_obj = id
      this.last_hit_time = get_time()
      play_sound("cb_hit")
      vx, vy = get_vel()
      vx2, vy2 = get_object_vel(id)
      speed = distance(0, 0, vx, vy)
      vx = vx - vx2
      vy = vy - vy2
      set_vel(-vx/2, -vy/2)
      cause_damage(id, speed/17.0)
      add_object_impulse(id, 87*vx, 87*vy)
      network_update(1)
    end
  end
end

