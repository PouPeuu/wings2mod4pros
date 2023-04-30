image = "bomb"
bounding_circle_radius = 3
mass = 30.0
volume = 0.1
air_resistance = 50.0

splint_speed = 150

function init(x_pos, y_pos, x_vel, y_vel, owner_id)
  px, py = get_object_pos(owner_id)
  vx, vy = get_object_vel(owner_id)
  px, py = find_last_clear_point(px, py, px+x_pos, py+y_pos)
  set_pos(px, py)
  set_vel(vx+x_vel, vy+y_vel)
  set_owner(owner_id)
  this.n = 0
  set_timer(0.1)
end

function network_init()
  this.n = 0
end


function on_timer()
  this.n = this.n + 1
  for i = 0,10 do
    speed = splint_speed * ((math.random() + math.random()) / 2)
    dir = math.random(360)
    dx, dy = get_dir_vector(dir)
    x_vel = speed * dx
    y_vel = speed * dy
    x, y = get_dir_vector(math.random(360))
    p = math.random(40)
    create_object("gas", p*x, p*y, x_vel, y_vel, get_id())
  end
  if this.n < 8 then
    set_timer(0.1)
  else
    kill()
  end
end

function on_hit_ground(cx, cy)
  px, py = get_pos()
  cx, cy = find_last_clear_point(cx, cy, px, py)
  set_pos(cx, cy)
  set_vel(0, 0)
end

