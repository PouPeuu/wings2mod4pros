animation = "cpulse"
loop_animation = true
bounding_circle_radius = 2
hit_damage = 0
hit_impulse = 0
mass = 1.0
volume = 0.02
air_resistance = 1.0
ground_kills = false
network_updates = true
has_dir = true
static_dir = true
send_reliably = true


function init(x_pos, y_pos, x_vel, y_vel, dir, owner_id)
  set_dir(dir)
  px, py = get_object_pos(owner_id)
  vx, vy = get_object_vel(owner_id)
  if (vx+x_vel)*(vx+x_vel) + (vy+y_vel)*(vy+y_vel) < (x_vel*x_vel) + (y_vel*y_vel) then
    vx = 0
    vy = 0
  end
  px, py = find_last_clear_point(px, py, px+x_pos, py+y_pos)
  set_pos(px, py)
  set_vel(vx+x_vel, vy+y_vel)
  set_owner(owner_id)
  this.last_hit_obj = 0
  this.last_hit_time = 0
  this.hits = 0
  set_timer(0.5)
end

function network_init()
  this.hits = 0
end

function on_timer()
  vx, vy = get_vel()
  if distance(vx, vy, 0, 0) < 120 then
    kill()
  end
  set_timer(0.5)
end

function on_hit_object(id)
  if get_object_type(id) ~= "pulse" then
    play_sound("pulse_hit")
    cause_damage(id, 5)
    vx, vy = get_vel()
    add_object_impulse(id, vx*10, vy*10)
    kill()
  end
  if get_object_type(id) == "fshield" then
    create_object("energy_explosion", 0, 0, 0, 0)
    kill()
  end
end

function on_hit_water(cx, cy)
  kill()
end

function on_hit_ground(cx, cy)

  this.hits = this.hits + 1
  if this.hits > 1 then
    kill()
    return
  end

  px, py = get_pos()
  x, y = find_last_clear_point(cx, cy, px, py)
  set_pos(x, y)
  vx, vy = get_vel()
  
  vx2 = -vx
  vy2 = -vy

  mx, my = get_map_pos(x, y)
  
  ax = 0
  ay = 0
  for y = -3, 3 do
    for x = -3, 3 do
      if x ~= 0 or y ~= 0 then
        if terrain.is_solid(get_map_type(mx+x, my+y)) then
          d = distance(x, y, 0, 0)
          ax = ax + (x / d)
          ay = ay + (y / d)
        end
      end
    end
  end
  nx = 0
  ny = 0
  d = distance(ax, ay, 0, 0)
  if d > 0 then
    nx = -ax / d
    ny = -ay / d
  end
  
  p = nx*(-vx) + ny*(-vy)
  vx2 = vx + 2*p*nx
  vy2 = vy + 2*p*ny
  
  set_vel(vx2, vy2)
  dir = get_vector_dir(vx2, vy2)
  set_dir(dir)
  network_update(1)
end

