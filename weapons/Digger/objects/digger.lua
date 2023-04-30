animation = "digger"
loop_animation = true

lifetime = 10
air_resistance = 10
mass = 10
volume = 0.2

bounding_circle_radius = 12

hit_damage = 0
hit_impulse = 0
touch_damage = 0

remote_callbacks = true
network_updates = true
send_reliably = true


impulse_x = 0
impulse_y = 0


function fillCircle(xCenter, yCenter, radius)
  impulse_x = 0
  impulse_y = 0
  r2 = radius * radius
  fillXLine(xCenter - radius, xCenter + radius, yCenter)
  for y = 1, radius do
    x = math.sqrt(r2 - y * y)
    fillXLine(xCenter - x, xCenter + x, yCenter + y)
    fillXLine(xCenter - x, xCenter + x, yCenter - y)
  end
    p = math.sqrt(impulse_x*impulse_x + impulse_y*impulse_y)
    if p > 10000 then
      impulse_x = 10000 * (impulse_x / p)
      impulse_y = 10000 * (impulse_y / p)
    end
    add_impulse(impulse_x, impulse_y)
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

  if terrain.is_solid(t) then 
    if not terrain.is_strong(t) and not terrain.is_indestructible(t) then
      -- destructible and soft ground
  
      impulse_x = impulse_x - 10*dx
      impulse_y = impulse_y - 10*dy
      r, g, b, a = get_map_color(x, y)
      remove_map_pixel(x, y)
      if math.random() > 0.75 then
        create_object("particle", dx+0.5+math.random(), dy+0.5+math.random(), 5*(sx-dx)-vx, 5*(sy-dy)-vy, r, g, b, 1, true, 1, 0)
      end
  
    else
    -- indestructible and hard ground
  
      impulse_x = impulse_x - 35*dx
      impulse_y = impulse_y - 35*dy
      if (dx^2 + dy^2) > 10 then
        cx, cy = find_last_clear_point(px, py, mx, my)
        dx2 = cx - px
        dy2 = cy - py
        if (dx2^2 + dy2^2) > 5 then
          speed = 20 * math.random()
          create_object("particle", dx2, dy2, speed*sx-vx, speed*sy-vy, 250, 250, 240, 1, true, 0.5*math.random(), 0)
        end
      end
      if terrain.is_strong(t) then
        remove_map_pixel(x, y)
      end
    end
  end
end


function init(x_pos, y_pos, owner_id)
  set_pos(x_pos, y_pos)
  attach_to(owner_id)
  set_owner(owner_id)
  set_timer(0.05)
  this.attached = 1
  this.update_time = 0
  this.release_time = 0
end

function network_init()
  this.attached = 1
  this.update_time = 0
  this.release_time = 0
end

function on_timer()
  if is_object_host(get_owner()) then
    px, py = get_pos()
    mx, my = get_map_pos(px, py)
    fillCircle(mx, my, 6)
    set_timer(0.05)
    if this.attached == 0 and get_time() > this.update_time + 0.1 then 
      this.update_time = get_time()
      network_update(1) 
    end
  end
end

function on_hit_ground(cx, cy)
  set_pos(cx, cy)
end

function on_hit_object(id)
  if is_server() then
    if id ~= get_owner() or (this.attached == 0 and (get_time() - this.release_time > 1.5)) then
      px, py = get_pos()
      ox, oy = get_object_pos(id)
      dx = ox - px
      dy = oy - py
      d = math.sqrt(dx^2 + dy^2)
      dt = get_dt()
      if d ~= 0 then
        sx = (dx - dy) / d
        sy = (dy - dx) / d
        add_object_impulse(id, 20000*sx*dt, 20000*sy*dt)
      end
      cause_damage(id, 60*dt)
      if get_object_type(id) == "dirtball" then 
        cause_damage(id, 1000*dt)
      end
    end
  end
end

function on_call()
  attach_to(0)
  this.attached = 0
  this.release_time = get_time()
  set_mass(30)
  network_update(2)
end

function write_data()
  write_int8(this.attached)
  write_int32(this.release_time*10)
end

function read_data()
  this.attached = read_int8()
  this.release_time = read_int32() / 10
end
