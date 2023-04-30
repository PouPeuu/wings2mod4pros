image = "wall_builder"
condition = 25.0
bounding_circle_radius = 6
mass = 100.0
volume = 1
air_resistance = 2000.0
has_dir = true
send_reliably = true
remote_callbacks = true


function init(x_pos, y_pos, x_vel, y_vel, dir, owner_id)
  px, py = get_object_pos(owner_id)
  vx, vy = get_object_vel(owner_id)
  px, py = find_last_clear_point(px, py, px+x_pos, py+y_pos)
  set_dir(dir)
  set_pos(px, py)
  set_vel(vx+x_vel, vy+y_vel)
  set_owner(owner_id)
  network_init()
end

function network_init()
  this.x = 0
  this.y = 0
  this.len = 0
  this.r = 0
  this.g = 0
  this.b = 0
  this.a = 0
  this.br = 1
end

function on_hit_ground(cx, cy)
  x, y = get_pos()
  sx, sy = find_first_solid_point(cx, cy, x, y)
  set_pos(sx, sy)

  if not is_server() then
    set_vel(0, 0)
    return
  end

  mx, my = get_map_pos_rel(0, 0)
  this.r, this.g, this.b, this.a = get_map_color(mx, my)
  this.a = 255
  a = this.r + this.g + this.b
  if a == 0 then
    this.r = 128
    this.g = 128
    this.b = 128
  elseif a < 128 then
    d = 128 / a
    this.r = this.r * d
    this.g = this.g * d
    this.b = this.b * d
  end
  
  attach_to_ground(1)

  this.x, this.y = get_pos()
  dx, dy = get_dir_vector(get_dir()+180)
  
  ex, ey = find_first_solid_point(cx+2*dx, cy+2*dy, cx+80*dx, cy+80*dy)
  this.len = distance(cx, cy, ex, ey) / 2
  
  this.x = this.x - dx
  this.y = this.y - dy
  set_timer(0.05)
end

function on_timer()

  if not is_server() then
    return
  end

  dir = get_dir() + 180
  dir_left = dir - 90
  dir_right = dir + 90
  dx, dy = get_dir_vector(dir)
  if math.abs(dx) > math.abs(dy) then
    dx = dx / math.abs(dx)
    dy = dy / math.abs(dx)
  else
    dx = dx / math.abs(dy)
    dy = dy / math.abs(dy)
  end
  lx, ly = get_dir_vector(dir_left)
  rx, ry = get_dir_vector(dir_right)

  this.x = this.x + dx*2
  px = this.x + lx * 4
  py = this.y + ly * 4
  px, py = get_map_pos(px, py)
  s1 = make_line(px, py, rx, ry, 5)

  this.y = this.y + dy*2
  px = this.x + lx * 4
  py = this.y + ly * 4
  px, py = get_map_pos(px, py)
  s2 = make_line(px, py, rx, ry, 5)

  this.len = this.len - 1
  
  set_pos(this.x, this.y)
  
  if this.len > 0 then
    set_timer(0.05)
  else
    kill()
  end
end



function make_line(x, y, dx, dy, len)
  space = false
  for i = 1, len do
    this.br = this.br + ((math.random() * 0.2) - 0.1)
    if this.br < 0.5 then this.br = 0.5 end
    if this.br > 1.5 then this.br = 1.5 end
    r = this.r * this.br
    g = this.g * this.br
    b = this.b * this.br
    a = this.a
    if r > 255 then r = 255 end
    if g > 255 then g = 255 end
    if b > 255 then b = 255 end
    if i == 1 then a = 128 end
    if i == len then a = 128 end
    t = get_map_type(x, y)
    if terrain.is_clear(t) or terrain.is_water(t) then
      set_map_pixel(x, y, terrain.Hard, r, g, b, a)
      space = true
    end
    x = x + dx
    y = y + dy
  end
  return space
end
