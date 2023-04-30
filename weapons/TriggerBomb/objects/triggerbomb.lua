image = "triggerbomb"
condition = 9.0
bounding_circle_radius = 2
hit_damage = 0
hit_impulse = 0
touch_damage = 0
mass = 20.0
volume = 0.2
air_resistance = 100
ground_kills = false
send_reliably = true
network_updates = true

color_r = 190
color_g = 190
color_b = 190
splint_speed = 180
min_time = 0.5


function init(x_pos, y_pos, x_vel, y_vel, owner_id)
  px, py = get_object_pos(owner_id)
  vx, vy = get_object_vel(owner_id)
  px, py = find_last_clear_point(px, py, px+x_pos, py+y_pos)
  set_pos(px, py)
  set_vel(vx+x_vel, vy+y_vel)
  set_owner(owner_id)
  this.triggered = false
  set_timer(0.2)
end

function network_init()
  this.triggered = false
  set_timer(0.2)
end

function explode()
  create_object("explosion3", 0, 0, 0, 0)
  kill()
end

function on_break()
  explode()
end

function on_call()
  if get_age() >= min_time then
    set_vel(0, 0)
    explode()
  else
    this.triggered = true
    set_timer(min_time-get_age())
  end
end


function on_timer()
  if this.triggered then
    set_vel(0, 0)
    explode()
  else
    network_update(1)
    set_timer(0.2)
  end
end




function on_hit_ground(cx, cy)

  px, py = get_pos()
  x, y = find_last_clear_point(cx, cy, px, py)
  set_pos(x, y)
  vx, vy = get_vel()
  
  speed = distance(0, 0, vx, vy)
  
  if speed > 20 then
  
    c = 0.25

    vx2 = -vx*c
    vy2 = -vy*c

    mx, my = get_map_pos(x, y)

    if vx > 0 then
      if terrain.is_solid(get_map_type(mx+1, my)) then
        vx2 = -vx*c
        vy2 = vy*c
      end
    else
      if terrain.is_solid(get_map_type(mx-1, my)) then
        vx2 = -vx*c
        vy2 = vy*c
      end
    end
    if vy > 0 then
      if terrain.is_solid(get_map_type(mx, my+1)) then
        vx2 = vx*c
        vy2 = -vy*c
      end
    else
      if terrain.is_solid(get_map_type(mx, my-1)) then
        vx2 = vx*c
        vy2 = -vy*c
      end
    end

    set_vel(vx2, vy2)
  
  else
   
    set_vel(0, 0)
  
  end

end

