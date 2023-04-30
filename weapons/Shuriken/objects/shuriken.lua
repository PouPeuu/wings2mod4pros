animation = "shuriken"
loop_animation = true
condition = 18.0
bounding_circle_radius = 3
hit_damage = 0
hit_impulse = 0
mass = 15.0
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
  this.last_sound_time = 0
  this.avel = 2600 * (math.random()-0.5)
end

function network_init()
  this.last_hit_obj = 0
  this.last_hit_time = 0
  this.last_sound_time = 0
  this.avel = 2600 * (math.random()-0.5)
end

function run_simulation()
  vx, vy = get_vel()
  dir = get_vector_dir(vx, vy)
  left = dir - 90
  fx, fy = get_dir_vector(left)
  add_force(this.avel * fx, this.avel * fy)
  if this.avel > 0 then
    this.avel = this.avel - 1000 * get_dt()
  else
    this.avel = this.avel + 1000 * get_dt()
  end
end

function on_hit_ground(cx, cy)
  px, py = get_pos()
  x, y = find_last_clear_point(cx, cy, px, py)
  set_pos(x, y)
  vx, vy = get_vel()
  
  speed = distance(0, 0, vx, vy)
  if speed < 60 then
    kill()
    return
  end

  if speed > 120 then
    if this.last_sound_time+0.5 < get_time() then
      v = speed / 300
      if v > 1 then v = 1 end
      play_sound("shuriken_hit", 100*v)
      this.last_sound_time = get_time()
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

  s = distance(0, 0, vx2, vy2)
  dir = get_vector_dir(vx2, vy2)
  dir = dir + math.abs(this.avel) * math.random() * 90
  vx, vy = get_dir_vector(dir)
  vx = vx * s
  vy = vy * s
  set_vel(vx, vy)

  --set_vel(vx2, vy2)
  network_update(1)
end

function on_hit_object(id)
  vx, vy = get_vel()
  vx2, vy2 = get_object_vel(id)
  speed = distance(0, 0, vx, vy)
  vx = vx - vx2
  vy = vy - vy2

  impulse_x = 10 * vx
  impulse_y = 10 * vy

  if get_object_max_condition(id) >= 20 then
    if this.last_hit_obj ~= id or this.last_hit_time+0.5 < get_time() then
      this.last_hit_obj = id
      this.last_hit_time = get_time()
      if this.last_sound_time+0.5 < get_time() then
        play_sound("shuriken_hit")
        this.last_sound_time = get_time()  
      end

      vx = -vx/2
      vy = -vy/2

      s = distance(0, 0, vx, vy)
      dir = get_vector_dir(vx, vy)
      dir = dir + math.abs(this.avel) * math.random() * 90
      vx, vy = get_dir_vector(dir)
      vx = vx * s
      vy = vy * s
      set_vel(vx, vy)
      impulse_x = impulse_x - 25*vx
      impulse_y = impulse_y - 25*vy
      network_update(1)
    end
  end

  if get_object_type(id) ~= "shuriken" then
    d = speed / 22.0
    if d > 16 then d = 16 end
    cause_damage(id, d)
  end
  add_object_impulse(id, impulse_x, impulse_y)

end

