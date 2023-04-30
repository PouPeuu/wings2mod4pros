image = "bomb"
condition = 10.0
bounding_circle_radius = 3
hit_damage = 0
hit_impulse = 0
touch_damage = 0
mass = 0.45
volume = 0.29
air_resistance = 5
send_reliably = true
solidity = 0.01
speed_limit = 350

speed = 220

splint_speed = 100

function init(x_pos, y_pos, x_vel, y_vel, owner_id)
  px, py = get_object_pos(owner_id)
  vx, vy = get_object_vel(owner_id)
  px, py = find_last_clear_point(px, py, px+x_pos, py+y_pos)
  set_pos(px, py)
  set_vel(vx+x_vel, vy+y_vel)
  set_owner(owner_id)
  this.destr = false
end

function on_hit_ground(cx, cy)
  px, py = get_pos()
  cx, cy = find_last_clear_point(cx, cy, px, py)
  set_pos(cx, cy)
  set_vel(0, 0)
  if not this.destr then
    set_timer(2)
    this.destr = true
  end
end

function on_timer()
  explode()
  kill()
end


function explode()
  play_sound("gasmine")
    for i = 0,9 do
      speed = splint_speed * ((math.random() + math.random()) / 2)
      dir = math.random(360)
      dx,dy = get_dir_vector(dir)
      x_vel = speed * dx
      y_vel = speed * dy
      x,y = get_dir_vector(math.random(360))
      p = math.random(20)
      create_object("minegas", p*x, p*y, x_vel, y_vel, get_id())
  end
end
	
function on_break()
  explode()
  kill()
end

function on_hit_object(id)
  if get_object_mass(id) >= 20 then
    explode()
    kill()
  end
end
