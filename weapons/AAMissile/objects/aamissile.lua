image = "aamissile"
condition = 7.0
bounding_circle_radius = 3
hit_damage = 10
hit_impulse = 50
touch_damage = 0
thrust = 10000.0
mass = 50.0
volume = 0.5
air_resistance = 1000.0
has_dir = true
static_dir = true
network_updates = true
turning_speed = 25

function init(x_pos, y_pos, x_vel, y_vel, dir, owner_id)
  px, py = get_object_shoot_pos(owner_id)
  vx, vy = get_object_vel(owner_id)
  px, py = find_last_clear_point(px, py, px+x_pos, py+y_pos)
  set_pos(px, py)
  set_vel(vx+x_vel, vy+y_vel)
  set_dir(dir)
  set_owner(owner_id)
  this.target = 0
  this.network_time = 0
  this.speed = distance(vx+x_vel, vy+y_vel, 0, 0)
  this.can_thrust = 1
  set_timer(0.05)
  set_effect("smoke_trail", true)
end

function network_init()
  this.target = 0
  this.network_time = 0
  this.speed = 0
  this.can_thrust = 1
  set_effect("smoke_trail", true)
end

function on_timer()
  dir = get_dir()
  x, y = get_pos()
  x_vel, y_vel = get_vel()
  this.speed = distance(x_vel, y_vel, 0, 0)

  if this.target ~= 0 and not is_alive(this.target) then
    this.target = 0
  end
    
  if this.target == 0 then
    x, y = get_pos()
    mindist = 500
    objs = get_objects_from(x, y, 300)
    for index, obj in pairs(objs) do
      t = get_object_type(obj)
      if t == "ship" or t == "AI_ship" or t == "plasma" or t == "smallflame" or t == "wf_flame" then
        tx, ty = get_object_pos(obj)
        if on_sector(tx, ty) and check_LOS(x, y, tx, ty, 5) then
	  tdist = distance(x, y, tx, ty)
	  if tdist < mindist then
	    mindist = tdist
            this.target = obj
          end
        end
      end
    end
  end
    
  if this.target ~= 0 then
    x, y = get_pos()
    tx, ty = get_object_pos(this.target)
    tdist = distance(x, y, tx, ty)
    if check_LOS(x, y, tx, ty, 5) and tdist < 300 then
      dir = get_dir()
      tdir = get_vector_dir(tx-x, ty-y)
      tchange = dir_change(dir, tdir) -- dir to target

      vdir = get_vector_dir(x_vel, y_vel)
      vchange = dir_change(vdir, tdir) -- vel to target

      if math.abs(tchange) >= turning_speed then
        change = tchange
      else
        a = math.min(this.speed, 300) / 300
        b = math.abs(vchange) / 180
        brakedir = get_vector_dir(-x_vel, -y_vel)
        bchange = dir_change(dir, brakedir)
        change = a * b * bchange + (1 - a * b) * tchange
      end

      diff = aim(change)
      if diff < 5 then 
        set_thrust(25000)
      else
        b = 1 - math.min(diff, 90) / 90
        set_thrust(b * 15000)
      end

    else
      this.target = 0
      set_thrust(10000)
    end
  end

  if get_age() > 4 then
    set_thrust(0)
    network_update(1)
    this.can_thrust = 0
  end
  
  if this.can_thrust == 1 then
    set_timer(0.05)
  else
    set_thrust(0)
    set_effect("smoke_trail", false)
  end

  if this.target ~= 0 then
    this.network_time = this.network_time + 1
    if this.network_time >= 1 then
      this.network_time = 0
      network_update(1)
    end
  end

end


function aim(dirc)
  dir = get_dir()
  if math.abs(dirc) <= turning_speed then
    set_dir(dir+dirc)
    return 0
  else
    dirc = dirc / math.abs(dirc) * turning_speed
    set_dir(dir+dirc)
    return math.abs(dirc) - turning_speed
  end
end

function on_sector(tx, ty)
  x, y = get_pos()
  dir = get_vector_dir(tx-x, ty-y)
  return (math.abs(dir_change(dir, get_dir())) <= 45)
end


function check_LOS(x1, y1, x2, y2, rad)
  lx, ly = find_first_solid_point(x1, y1, x2, y2)
  if distance(lx, ly, x2, y2) > rad then return false end
  return true
end


function explode()
  create_object("small_explosion", 0, 0, 0, 0)
  kill()
end

function on_hit_ground(cx, cy)
  set_pos(cx, cy)
  explode()
end

function on_hit_water(cx, cy)
  set_thrust(0)
  network_update(1)
  this.can_thrust = 0
end

function on_emp_hit(power)
  set_thrust(0)
  network_update(1)
  this.can_thrust = 0
end

function on_hit_object(id)
  type = get_object_type(id)
  if get_object_max_condition(id) >= 20 then
    set_vel(0, 0)
    explode()
  end
end

function on_break()
  explode()
end

