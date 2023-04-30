animation = "gravity_obj_create" 
loop_animation = true 
bounding_circle_radius = 7 
lifetime = 40 
mass = 0.1 
shoot_from_inside = false

check_hits = true 
remote_callbacks = true 
remote_check_hits = true 
network_updates = true

function init(px, py, platform_id)

  set_pos(px, py)
  attach_to(platform_id)
  set_attach_pos(0, 30, 0, false)
  set_owner(platform_id)

  this.attached = 0
  this.attach_time = 0
  this.dist = 30
  set_timer(0.25)

end

function network_init()

  this.dist = 30
  this.attached = 0
  this.attach_time = 0
  set_timer(0.25)

end


function on_timer()
  set_animation("gravity_obj")
end


function write_data()

  write_int32(this.attached)

end

function read_data()

  this.attached = read_int32()

end

function on_hit_object(id)

  if id == get_owner() then return end

  if get_object_type(id) == "wave_particle_3" then
    kill_object(id)
    return
  end

  if not is_server() and this.attached == 0 then return end

  px, py = get_pos()
  ox, oy = get_object_pos(id)

  dx, dy = get_object_vel(get_owner())
  
  if get_object_type(id) == "gravity_obj" then
    if this.attached ~= 0 and this.attach_time < get_time()-0.5 then
      vx, vy = get_object_vel(get_owner())
      set_object_vel(this.attached, vx, vy)
      kill()
    end
    return
  end

  if get_object_type(id) == "wormhole_start" then
    kill()
    if this.attached ~= 0 then
      vx, vy = get_object_vel(get_owner())
      set_object_vel(this.attached, vx, vy)
    end
    return
  end


-- set_text(get_object_mass(id))

  if get_object_mass(id) > 1.1 and get_object_mass(id) < 90 and (this.attached == 0 or this.attached == id) and
     get_object_type(id) ~= "wormhole_start" and get_object_type(id) ~= "wormhole_end" and
     get_object_type(id) ~= "emp" and
     get_object_type(id) ~= "laser" and get_object_type(id) ~= "digger" and get_object_type(id) ~= "fshield"
  then
 
    if this.attached ~= id then
      this.attached = id
      this.attach_time = get_time()
      run_simulation()
      network_update(2)
    end

  end

end

function on_call()

  attach_to(0)

  id = get_id()

  bx, by = get_object_vel(id)
  px, py = get_dir_vector(get_object_dir(get_owner()))

  platform_vel_x, platform_vel_y = get_object_vel(get_owner())
  set_object_vel(this.attached, platform_vel_x, platform_vel_y)
  
  i = 10000
  if i / get_object_mass(this.attached) > 500 then
    i = 500 * get_object_mass(this.attached)
  end
  add_object_impulse(this.attached, i*px, i*py)

  kill()

end

function on_hit_ground()

  kill()

end


function run_simulation()

  px, py = get_pos()
  mx, my = get_map_pos(px, py)
  platform = get_owner()

  dist = this.dist

  if not terrain.is_solid(get_map_type(mx, my)) or dist == 1 then
    --Siirret‰‰n l‰hennetty GG kauemmas
    if dist < 30 then         
 
      --Haetaan aluksen suunta
      dx, dy = get_dir_vector(get_object_dir(platform))
      
      x1, y1 = get_object_pos(platform)

      norm_x = x1 + 30 * dx
      norm_y = y1 + 30 * dy
      
      --Haetaan viimeisin hyv‰ paikka (ei sein‰)
      x2, y2 = find_last_nonsolid_point(x1, y1, norm_x, norm_y)
      px = x2
      py = y2

      --Haetaan et‰isyys sein‰n reunaan
      dist = distance(x1, y1, x2, y2)
      dist = math.floor(dist)
      
      if dist == 0 then
        dist = 1
      end
      
      set_attach_pos(0, dist, 0, false)
      this.dist = dist
      
      --Voima joka vastustaa gg:n objektin tyˆtˆ‰ sein‰‰n
      if dist < 28 then
        add_object_force(platform, -1*dx*(28-dist)*5000, -1*dy*(28-dist)*5000)
      end
             
      set_attach_pos(0, dist, 0, false)
      this.dist = dist
    end

  else
    --Aluksen paikka   
    x1, y1 = get_object_pos(platform)

    --Haetaan viimeisin hyv‰ paikka (ei sein‰)
    x2, y2 = find_last_nonsolid_point(x1, y1, px, py)
    px = x2
    py = y2

    --Haetaan et‰isyys sein‰n reunaan
    dist = distance(x1, y1, x2, y2)
    dist = math.floor(dist)

    if dist == 0 then
      dist = 1
    end
    
    if dist < 30 then
      set_attach_pos(0, dist, 0, false)
      this.dist = dist
    end
  end
 
  
  if this.attached ~= 0 then
    if not is_alive(this.attached) then
      kill()
    else
      m = get_object_mass(this.attached)
      if m >= 90 then 
        kill() 
      else
        set_mass(m)
        
        x1, y1 = get_object_pos(this.attached)
        if is_server() and distance(x1, y1, px, py) > 30 then
          kill()
        else
          set_object_pos(this.attached, px, py, ID_LOCAL)
          set_object_vel(this.attached, 0, 0)
        end
      end
    end
  end
end

