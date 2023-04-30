pixel_size = 2
pixel_alpha = 255
pixel_r = 100
pixel_g = 100
pixel_b = 100

hit_damage = 0
hit_impulse = 0
touch_damage = 0
mass = 10.0
volume = 0.1
air_resistance = 10

function init(x_pos, y_pos, x_vel, y_vel, owner_id)
  px, py = get_object_shoot_pos(owner_id)
  vx, vy = get_object_vel(owner_id)
  px, py = find_last_clear_point(px, py, px+x_pos, py+y_pos)
  set_pos(px, py)
  set_vel(vx+x_vel, vy+y_vel)
  set_owner(owner_id)
end


function on_hit_ground(cx, cy)
  set_vel(0, 0)
  deploy(cx, cy)
  kill()
end

function deploy(cx, cy)
  mx, my = get_map_pos(cx, cy)
  i = math.random(20) - 10
  makePoint(mx, my, 90+i, 110+i, 100+i, 255)
end

function makePoint(x, y, r, g, b, a)
  t = get_map_type(x, y)

  sg = 0
  if terrain.is_solid(get_map_type(x+1, y)) then sg = sg + 1 end
  if terrain.is_solid(get_map_type(x-1, y)) then sg = sg + 1 end
  if terrain.is_solid(get_map_type(x, y+1)) then sg = sg + 1 end
  if terrain.is_solid(get_map_type(x, y-1)) then sg = sg + 1 end
  if terrain.is_solid(get_map_type(x+1, y+1)) then sg = sg + 1 end
  if terrain.is_solid(get_map_type(x-1, y+1)) then sg = sg + 1 end
  if terrain.is_solid(get_map_type(x+1, y-1)) then sg = sg + 1 end
  if terrain.is_solid(get_map_type(x-1, y-1)) then sg = sg + 1 end

  if sg > 2 then
    if terrain.is_clear(t) or terrain.is_water(t) then
      set_map_pixel(x, y, terrain.Hard, r, g, b, a)
    end
  end
end
