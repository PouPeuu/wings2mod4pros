animation = "wormhole_start"
loop_animation = true
bounding_circle_radius = 16
lifetime = 45
static = true
remote_callbacks = true
send_reliably = true
release_time = 1


function init(endpoint_id, owner_id)
  px, py = get_object_pos(owner_id)
  set_pos(px, py)
  set_owner(owner_id)
  this.endpoint = endpoint_id
  if this.endpoint ~= 0 then
    set_timer(0)
  end
end


function on_lifetime_end()
  if this.endpoint ~= 0 and is_alive(this.endpoint) then
    call_object(this.endpoint, 0)
  end
end


x_change = 0
y_change = 0

function on_timer()
  x, y = get_pos()
  mx, my = get_map_pos(x, y)
  x2, y2 = get_object_pos(this.endpoint)
  mx2, my2 = get_map_pos(x2, y2)
  x_change = mx2 - mx
  y_change = my2 - my
  fillCircle(mx, my, 7)
  set_timer(0.05)
end


function on_hit_object(id)
  t = get_object_type(id)

  if not is_server() then
    if t == "ship" or t == "pilot" then return end
  end
  
  if t == "laser" then kill() call_object(this.endpoint, 0) return end
  if t ~= "wormhole_start" and t ~= "wormhole_end" and t ~= "EMP_object" and t ~= "factory" then
    if this.endpoint ~= 0 and is_alive(this.endpoint) then
      x, y = get_object_pos(this.endpoint)
      set_object_pos(id, x, y)
    end
  end
end


function on_call()
  kill()
  if this.endpoint ~= 0 and is_alive(this.endpoint) then
    call_object(this.endpoint, 0)
  end
end


function write_data()
  write_int32(this.endpoint)
end

function read_data()
  this.endpoint = read_int32()
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
  
  if terrain.is_clear(t) or terrain.is_indestructible(t) then 
    -- do nothing
  else
    t2 = get_map_type(x+x_change, y+y_change)
    if terrain.is_clear(t2) then
      if terrain.is_water(t) then t = terrain.Water end
      if terrain.is_sand(t) then t = terrain.Sand end
      r, g, b, a = get_map_color(x, y)
      local_remove_map_pixel(x, y)
      local_set_map_pixel(x+x_change, y+y_change, t, r, g, b, a)
    end
  end
end

