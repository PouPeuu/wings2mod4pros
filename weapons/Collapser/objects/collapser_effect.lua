animation="collapser"
ground_kills = false
remote_callbacks = true
send_reliably = true


function init(radius, owner_id)
  px, py = get_object_pos(owner_id)
  set_pos(px, py)
  set_owner(owner_id)
  set_timer(0.1)
  network_init()
  this.radius = radius
end

function network_init()
  this.radius = 0
end


function write_data()
  write_int8(this.radius)
end


function read_data()
  this.radius = read_int8()

  -- Make sure to run the timer even if it was already
  -- done in the server
  if not timer_is_set() then 
    set_timer(0.1) 
  end
end


function on_timer()
  mx, my = get_map_pos_rel(0, 0)
  fillCircle(mx, my, this.radius)
  kill_local()
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
  t = get_map_type(x, y)
  
  if terrain.is_solid(t) and not terrain.is_indestructible(t) and t ~= terrain.Base then 
    if this.radius < 10 or not terrain.is_strong(t) then
      r, g, b, a = get_map_color(x, y)
      local_set_map_pixel(x, y, terrain.Sand, r, g, b, a)
    end
  end
end

