image = "turret_gun"
hit_image = "turret_gun_hit"
condition = 45.0
bounding_circle_radius = 7
mass = 100.0
volume = 1
air_resistance = 1500.0
has_dir = true
attached_part = true
network_updates = true
send_reliably = true
poison_effect = 0.05



turning_speed = 3
clip_size = 20
loading_time = 4

function init(turret_id, owner_id)
  network_init()
  attach_to(turret_id)
  set_owner(owner_id)
  set_attach_pos(180, 3, 0, false)
  this.turret_id = turret_id
  this.turret_dir = get_object_dir(turret_id) + 180
  set_dir(this.turret_dir)
  set_team(get_object_team(turret_id))
  set_timer(0.05)
end

function network_init()
  this.turret_dir = 0
  this.target = 0
  this.clip = clip_size
  this.load_start = 0
  this.burst = 0
  this.network_time = 0
  this.emp_effect = 0
  this.emp_effect_time = 0
  this.freezer_effect = 0
  this.ice_time = 0
end


function on_timer()
  dir = get_dir()
  set_dir(dir + ((get_object_dir(this.turret_id)+180) - this.turret_dir))
  this.turret_dir = get_object_dir(this.turret_id)+180

  if this.emp_effect_time > 0 then
    this.emp_effect_time = this.emp_effect_time - 0.05
    if this.emp_effect_time <= 0 then
      call_object(this.emp_effect)
    end
    set_timer(0.05)
    return
  end

  if this.ice_time > 0 then
    -- print(this.ice_time)
    this.ice_time = this.ice_time - 0.05
    if this.ice_time <= 0 then
      -- print("calling fe")
      call_object(this.freezer_effect)
    end
    set_timer(0.05)
    return
  end



  if this.target ~= 0 and not is_alive(this.target) then
    this.target = 0
  end
  
  fx, fy = get_force()
  if distance(0, 0, fx, fy) > 35000 then
    call_object(this.turret_id, "free")
  end

  px, py = get_object_pos(this.turret_id)
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
    call_object(this.turret_id, "free")
  end
  
  
  if this.target == 0 then
    team = get_object_team(get_id())
    x, y = get_pos()
    objs = get_objects_from(x, y, 200)
    for index, obj in pairs(objs) do
      if obj ~= get_id() and obj ~= this.turret_id then
        c = get_object_max_condition(obj)
        if c >= 8 and get_object_team(obj) ~= team and get_object_type(obj) ~= "flag" then
          tx, ty = predict_pos(obj)
          if on_sector(tx, ty) and check_LOS(x, y, tx, ty, 5) then
            this.target = obj
            break
          end
        end
      end
    end
  end
  
  
  if this.target ~= 0 then
    x, y = get_pos()
    tx, ty = predict_pos(this.target)
    if on_sector(tx, ty) and check_LOS(x, y, tx, ty, 5) and distance(x, y, tx, ty) < 220 then
      aim(tx, ty)
    else
      this.target = 0
    end
  end

  if this.burst > 0 then
    shoot()
    this.burst = this.burst - 1
  end

  if this.clip == 0 then  
    if get_time() > this.load_start + loading_time then
      this.clip = clip_size
    end
  end

  if this.target ~= 0 then
    this.network_time = this.network_time + 1
    if this.network_time >= 2 then
      this.network_time = 0
      network_update(1)
    end
  end
  
  set_timer(0.05)
end


function predict_pos(obj)
  x, y = get_pos()
  tx, ty = get_object_pos(obj)
  dist = distance(x, y, tx, ty)
  tvx, tvy = get_object_vel(obj)
  t1 = dist / 300
  tx = tx + tvx*t1
  ty = ty + tvy*t1
  return tx, ty  
end



function aim(tx, ty)
  x, y = get_pos()
  tdir = get_vector_dir(tx-x, ty-y)
  dir = get_dir()
  c = dir_change(dir, tdir)
  if math.abs(c) < 2 then
    set_dir(tdir)
    this.burst = this.clip
  else
    c = c / math.abs(c) * turning_speed
    set_dir(dir+c)
  end
end


function shoot()
  if build_time_on() then return end
  dx, dy = get_dir_vector(get_dir())
  create_object("shot", dx*4, dy*4, 300*dx, 300*dy)
  if this.clip == clip_size then
    play_sound("turret_gun")
  end
  this.clip = this.clip - 1
  if this.clip == 0 then
    this.load_start = get_time()
  end
end


function on_sector(tx, ty)
  x, y = get_pos()
  dir = get_vector_dir(tx-x, ty-y)
  return (math.abs(dir_change(dir, this.turret_dir)) <= 90)
end


function check_LOS(x1, y1, x2, y2, rad)
  lx, ly = find_first_solid_point(x1, y1, x2, y2)
  if distance(lx, ly, x2, y2) > rad then return false end
  
  team = get_object_team(get_id())
  objs = get_objects_from_line(x1, y1, x2, y2, rad)
  for index, obj in pairs(objs) do
    if obj ~= get_id() and obj ~= this.turret_id then
      c = get_object_max_condition(obj)
      if c >= 8 and get_object_team(obj) == team then
        return false
      end
    end
  end
  return true
end


function on_hit_object(id)
  if get_object_type(id) == "freezer" then
    -- print("hit freezer", this.ice_time)
    if this.ice_time <= 0 then
      this.freezer_effect = create_object("freezer_effect", get_id())
      -- print("created", this.freezer_effect)
    end
    this.ice_time = 8
  end
end

function on_emp_hit(power)
  if this.emp_effect_time <= 0 then
    this.emp_effect = create_object("emp_effect", get_id())
  end
  this.emp_effect_time = power
end

function on_break()
  call_object(this.turret_id, "kill")
  for i = 0, 12 do
    rd = math.random(360)
    rx, ry = get_dir_vector(rd)
    rs = 0.3 + 0.7*math.random()
    create_object("fragment", 8*rx*rs, 8*rx*rs, 140*rs*rx, 140*rs*ry, get_id())
  end
end


function write_data()
  write_int32(this.turret_id)
end

function read_data()
  this.turret_id = read_int32()
end
