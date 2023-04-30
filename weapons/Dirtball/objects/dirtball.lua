animation = "dirtball"
condition = 200.0
bounding_circle_radius = 2
hit_damage = 0
hit_impulse = 0
touch_damage = 0
normal_mass = 65.0
mass = normal_mass
volume = 0.1
air_resistance = 1250.0
ground_kills = true
remote_callbacks = true
remote_check_hits = true
send_reliably = true
network_updates = true

function init(x_pos, y_pos, x_vel, y_vel, owner_id)
  px, py = get_object_pos(owner_id)
  vx, vy = get_object_vel(owner_id)
  px, py = find_last_clear_point(px, py, px+x_pos, py+y_pos)
  set_pos(px, py)
  set_vel(vx+x_vel, vy+y_vel)
  set_owner(owner_id)
  this.attached = {}
  set_timer(0.25)
end

function network_init()
  this.attached = {}
  set_timer(0.25)
end

function write_data()
  n = 0
  for k, obj in pairs(this.attached) do
    n = n + 1
  end
  write_int8(n)
  for k, obj in pairs(this.attached) do
    write_int32(obj)
  end
end

function read_data()
  this.attached = {}
  n = read_int8()
  for i = 1, n do
    obj = read_int32()
    this.attached[obj] = obj
  end
end

function on_timer()
  if not is_server() then return end
  network_update(1)
  set_timer(0.25)
end


function on_hit_object(id)
  if not is_server() then return end
  
  if is_solid(id) and get_object_mass(id) < 200 and this.attached[id] == nil and get_object_type(id) ~= "firebomb" then
    n = 0
    for k, obj in pairs(this.attached) do
      n = n + 1
    end
    if n < 5 then
      vx1, vy1 = get_vel()
      vx2, vy2 = get_object_vel(id)
      m1 = get_object_mass(get_id())
      m2 = get_object_mass(id)
      set_vel((m1*vx1+m2*vx2)/(m1+m2), (m1*vy1+m2*vy2)/(m1+m2))
      
      if get_object_type(id) == "dirtball" then
        if is_alive(get_id()) then
          kill_object(id)
        end
        return
      end

      this.attached[id] = id
      set_hold(id, get_id())
      run_simulation()
      network_update(2)
    end
  end
  
end


function run_simulation()
  m = normal_mass
  fx = 0
  fy = 0
  for k, id in pairs(this.attached) do
    px, py = get_pos()
    set_object_pos(id, px, py, ID_LOCAL)
    set_object_vel(id, 0, 0)
    m = m + get_object_mass(id)
    fx1, fy1 = get_object_force(id)
    fx = fx + fx1
    fy = fy + fy1
  end
  set_mass(m)
  -- add_force(fx, fy) -- doesn't work in network game
end


function on_hit_ground(cx, cy)
  if not is_server() then return end
  
  px, py = get_pos()
  cx, cy = find_last_clear_point(cx, cy, px, py)
  set_pos(cx, cy)
  set_vel(0, 0)
  deploy()
  kill()
end

function deploy()
  px, py = get_pos()
  vx, vy = get_vel()
  mx, my = get_world_pos(x, y)
  dx = mx - px
  dy = my - py
  sx = -dy
  sy = dx

  for i = 0,10 do
    pardir = math.random(360)
    parx, pary = get_dir_vector(pardir)
    speed = 80 + 20 * math.random()
    r = math.random(50)+120
    g = math.random(10)+80
    b = math.random(10)
    create_object("particle", parx*12, pary*12, parx*speed, pary*speed, 
                  r, g, b, 1, 1, 3, 0.75)
  end

  px, py = get_pos()
  mx, my = get_map_pos(px, py)
  fillCircle(mx, my, math.random(5, 6))
end

function fillCircle(xCenter, yCenter, radius)
  r2 = radius * radius
  fillXLine(xCenter - radius, xCenter + radius, yCenter)
  for y = 1, radius do
    x = math.sqrt(r2 - y * y)
    fillXLine(xCenter - x, xCenter + x, yCenter + y)
    fillXLine(xCenter - x, xCenter + x, yCenter - y)
  end
end

function fillXLine(xmin, xmax, y)
  for i = xmin, xmax do
    makePoint(i, y)
  end
end

function makePoint(x, y)
  px, py = get_pos()
  vx, vy = get_vel()
  mx, my = get_world_pos(x, y)
  dx = mx - px
  dy = my - py
  sx = -dy
  sy = dx
  t = get_map_type(x, y)

  if terrain.is_clear(t) or terrain.is_water(t) then -- add mud
    r = math.random()*60+120
    g = math.random()*20+70
    b = math.random()*10
    a = 255
    set_map_pixel(x, y, 17, r, g, b, a)
  end
end

