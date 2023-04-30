bounding_circle_radius = 2
hit_damage = 0
hit_impulse = 0
mass = 0.5
volume = 0.02
air_resistance = 5.0
ground_kills = false
send_reliably = true
touch_damage = 5
lifetime = 0.7
remote_callbacks = true


function init(x_pos, y_pos, x_vel, y_vel, owner_id)
  px, py = get_object_pos(owner_id)
  vx, vy = get_object_vel(owner_id)
  px, py = find_last_clear_point(px, py, px+x_pos, py+y_pos)
  set_pos(px, py)
  set_vel(vx+x_vel, vy+y_vel)
  set_owner(owner_id)
  network_init()
end

function network_init()
  set_timer(0.2)
end


function on_timer()

  dir = 360 * math.random()
  dx, dy = get_dir_vector(dir)
  speed = 50 * math.random()
  create_local_object("wf_flame", dx, dy, speed*dx, speed*dy, get_id())

  set_timer(0.25)
end




function on_hit_ground(cx, cy)

  if not is_server then return end
  
  px, py = get_pos()
  x, y = find_last_clear_point(cx, cy, px, py)
  set_pos(x, y)
  vx, vy = get_vel()
  
  speed = distance(0, 0, vx, vy)

  vx2 = -vx*0.2
  vy2 = -vy*0.2

  mx, my = get_map_pos(x, y)

  if vx > 0 then
    if terrain.is_solid(get_map_type(mx+1, my)) then
      vx2 = -vx*0.2
      vy2 = vy*0.2
    end
  else
    if terrain.is_solid(get_map_type(mx-1, my)) then
      vx2 = -vx*0.2
      vy2 = vy*0.2
    end
  end
  if vy > 0 then
    if terrain.is_solid(get_map_type(mx, my+1)) then
      vx2 = vx*0.2
      vy2 = -vy*0.2
    end
  else
    if terrain.is_solid(get_map_type(mx, my-1)) then
      vx2 = vx*0.2
      vy2 = -vy*0.2
    end
  end

  set_vel(vx2, vy2)

end

