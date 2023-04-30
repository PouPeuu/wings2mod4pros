image = "firebomb_1"
loop_animation = true
condition = 1000.0
bounding_circle_radius = 4
hit_damage = 0
hit_impulse = 0
mass = 75.0
volume = 0.2
solidity = 0.2
air_resistance = 15.0
ground_kills = false
send_reliably = true
network_updates = true
touch_damage = 30
remote_callbacks = true


function init(x_pos, y_pos, x_vel, y_vel, owner_id)
  px, py = get_object_pos(owner_id)
  vx, vy = get_object_vel(owner_id)
  px, py = find_last_clear_point(px, py, px+x_pos, py+y_pos)
  set_pos(px, py)
  set_vel(vx+x_vel, vy+y_vel)
  set_owner(owner_id)
  network_init()
end

function network_init()
  this.last_hit_obj = 0
  this.last_hit_time = 0
  this.lit_time = 0
  set_timer(0.1)
end

function write_data()
  a = 0
  if this.lit_time > 0 then a = 1 end
  write_int8(a)
end

function read_data()
  a = this.lit_time
  this.lit_time = read_int8()
  if a == 0 and this.lit_time == 1 then
    set_animation("firebomb_2")
  end
end



function on_timer()

  if this.lit_time > 0 then
    for i = 1, 1 do
      dir = 360 * math.random()
      dx, dy = get_dir_vector(dir)
      speed = 50 * math.random()
      create_local_object("wf_flame", dx, dy, speed*dx, speed*dy, get_id())
    end

    if math.random() < 0.2 then
      vx, vy = get_vel()
      create_local_object("wildfire", 0, 0, -vx/2, -vx/2, get_id())
    end

    if is_server() then
      x, y = get_pos()
      objs = get_objects_from(x, y, 24)
      for index, obj in pairs(objs) do
        if get_object_type(obj) == "factory" then
          x2, y2 = get_object_pos(obj)
          y2 = y2 + 11
          dist = distance(x, y, x2, y2)
          if dist < 13 then
            dx = x - x2
            dy = y - y2
            dy = dy / 4
            dir = get_vector_dir(dx, dy)
            dx, dy = get_dir_vector(dir)
            p = (26.0 - dist) / 13.0
            add_impulse(p*250*dx, p*250*dy)
          end
        end
      end

    end

  else
    if is_server() then
      if get_condition() < 1000-3 then
        lit()
      end
    end
  end

  set_timer(0.05)
end


function lit()
  set_animation("firebomb_2")
  this.lit_time = get_time()
  play_sound("wf_hit")

  for i = 1, 12 do
    dir = 360 * math.random()
    dx, dy = get_dir_vector(dir)
    speed = 50 * math.random()
    dist = 5 + 7 * math.random()
    create_object("wf_flame", dist*dx, dist*dy, speed*dx, speed*dy, get_id())
  end

end


function on_hit_ground(cx, cy)

  if not is_server() then return end
  
  px, py = get_pos()
  x, y = find_last_clear_point(cx, cy, px, py)
  set_pos(x, y)
  vx, vy = get_vel()
  
  speed = distance(0, 0, vx, vy)

  if speed > 150 then
    play_sound("wf_hit2")
  elseif speed > 75 then
    play_sound("wf_hit2", 64)
  end

  vx2 = -vx*0.4
  vy2 = -vy*0.4

  mx, my = get_map_pos(x, y)

  if vx > 0 then
    if terrain.is_solid(get_map_type(mx+1, my)) then
      vx2 = -vx*0.4
      vy2 = vy*0.4
    end
  else
    if terrain.is_solid(get_map_type(mx-1, my)) then
      vx2 = -vx*0.4
      vy2 = vy*0.4
    end
  end
  if vy > 0 then
    if terrain.is_solid(get_map_type(mx, my+1)) then
      vx2 = vx*0.4
      vy2 = -vy*0.4
    end
  else
    if terrain.is_solid(get_map_type(mx, my-1)) then
      vx2 = vx*0.4
      vy2 = -vy*0.4
    end
  end

  set_vel(0, 0)
  if this.lit_time == 0 then
    lit()
  end

  set_vel(vx2, vy2)
  network_update(1)

  if get_time() > this.lit_time + 7 then 
    kill() 
  end
end



function on_hit_object(id)

  if not is_server() then return end

  if get_object_max_condition(id) >= 20 then
    if this.last_hit_obj ~= id or this.last_hit_time+0.5 < get_time() then
      if this.lit_time == 0 then
        lit()
      end

      this.last_hit_obj = id
      this.last_hit_time = get_time()
      vx, vy = get_vel()
      vx2, vy2 = get_object_vel(id)
      speed = distance(0, 0, vx, vy)
      if get_object_mass(id) > 25 then
        set_vel(vx/2.5, vy/2.5)
      end
      cause_damage(id, speed/17.0)
      add_object_impulse(id, 40*vx, 40*vy)
      network_update(1)
    end
 
  end
end



