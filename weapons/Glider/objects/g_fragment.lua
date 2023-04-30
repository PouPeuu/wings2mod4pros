animation = "g_fragment"
mass = 30.0
volume = 0.5
air_resistance = 100.0
has_dir = true


function init(x_pos, y_pos, x_vel, y_vel, owner_id)
  px, py = get_object_pos(owner_id)
  vx, vy = get_object_vel(owner_id)
  px, py = find_last_clear_point(px, py, px+x_pos, py+y_pos)
  set_pos(px, py)
  set_vel(vx+x_vel, vy+y_vel)
  set_owner(owner_id)
  set_dir(math.random(360))
  set_lifetime(0.15+0.3*math.random())
  set_angular_vel(math.random(6000)-3000)
end

function network_init()
  set_dir(math.random(360))
  set_lifetime(0.15+0.4*math.random())
  set_angular_vel(math.random(10000)-5000)
end

