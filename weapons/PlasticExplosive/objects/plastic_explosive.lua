image = "plastic_explosive"
condition = 5.0
bounding_circle_radius = 4
hit_damage = 0
hit_impulse = 0
touch_damage = 0
mass = 40.0
volume = 0.1
air_resistance = 10

function init(x_pos, y_pos, x_vel, y_vel, owner_id)
  px, py = get_object_pos(owner_id)
  vx, vy = get_object_vel(owner_id)
  px, py = find_last_clear_point(px, py, px+x_pos, py+y_pos)
  set_pos(px, py)
  set_vel(vx+x_vel, vy+y_vel)
  set_owner(owner_id)
  this.last_gr_x = 0
  this.last_gr_y = 0
end


function on_hit_ground(cx, cy)
  if not is_server then return end
  
  px, py = get_pos()
  
  mx, my = get_map_pos(px, py)
  r, g, b, a = get_map_color(mx, my)
  
--  cx, cy = find_last_clear_point(cx, cy, px, py)
--  set_pos(cx, cy)
  set_vel(0, 0)
  deploy(r, g, b, a)
  kill()
end

function on_break()
  if get_age() > 0.3 then
    create_object("plastic_explosion", 0, 0, 0, 0)
  end
end

function deploy(r, g, b, a)
  px, py = get_pos()
  mx, my = get_map_pos(px, py)
  fillCircle(mx, my, 3, r, g, b, a)
end

function fillCircle(xCenter, yCenter, radius, r, g, b, a)
--  r2 = radius * radius
--  fillXLine(xCenter - radius, xCenter + radius, yCenter, r, g, b, a)
--  for y = 1, radius do
--    x = math.sqrt(r2 - y * y)
--    fillXLine(xCenter - x, xCenter + x, yCenter + y, r, g, b, a)
--    fillXLine(xCenter - x, xCenter + x, yCenter - y, r, g, b, a)
--  end

  fillXLine(xCenter-1, xCenter+1, yCenter-2, r, g, b, a)
  fillXLine(xCenter-2, xCenter+2, yCenter-1, r, g, b, a)
  fillXLine(xCenter-2, xCenter+2, yCenter  , r, g, b, a)
  fillXLine(xCenter-2, xCenter+2, yCenter+1, r, g, b, a)
  fillXLine(xCenter-1, xCenter+1, yCenter+2, r, g, b, a)
end

function fillXLine(xmin, xmax, y, r, g, b, a)
  for i = xmin, xmax do
    makePoint(i, y, r, g, b, a)
  end
end

function makePoint(x, y, r, g, b, a)
  px, py = get_pos()
  vx, vy = get_vel()
  mx, my = get_world_pos(x, y)
  dx = mx - px
  dy = my - py
  sx = -dy
  sy = dx
  t = get_map_type(x, y)

  if terrain.is_clear(t) or terrain.is_water(t) then
    if a < 220 then a = 220 end
    d = math.random() * 0.4 + 0.8
    if r+g+b < 128 then d = d + 0.2 end
    r = r * d
    g = g * d
    b = b * d
    if r+g+b < 100 then 
      k = (100-(r+g+b)) / 3
      r = r + k
      g = g + k
      b = b + k
    end
    if r < 0 then r = 0 end 
    if r > 255 then r = 255 end
    if g < 0 then g = 0 end 
    if g > 255 then g = 255 end
    if b < 0 then b = 0 end 
    if b > 255 then b = 255 end
    set_map_pixel(x, y, terrain.PlasticExplosive, r, g, b, a)
  end
end

function read_data()
  this.last_gr_x = 0
  this.last_gr_y = 0
end
