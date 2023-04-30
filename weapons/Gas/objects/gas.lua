image = "gas"

condition = 0
air_resistance = 5
mass = 0.09
volume = 0.04
bounding_circle_radius = 15
hit_damage = 0
hit_impulse = 0
poison_damage = 6.0
remote_callbacks = true


function my_random()
  this.rnd = math.fmod((this.rnd * 1243089013 + 112341), 23452655627)
  return (this.rnd / 23452655627)
end


function init(x_pos, y_pos, x_vel, y_vel, owner_id)
  px, py = get_object_pos(owner_id)
  vx, vy = get_object_vel(owner_id)
  px, py = find_last_clear_point(px, py, px+x_pos, py+y_pos)
  set_pos(px, py)
  set_vel(vx+x_vel, vy+y_vel)
  set_owner(owner_id)
  this.rnd = math.abs(math.floor(x_vel*y_vel))
  on_timer()
end

function on_hit_ground(cx, cy)
  px, py = get_pos()
  cx, cy = find_last_clear_point(cx, cy, px, py)
  set_pos(cx, cy)
  set_vel(0, 0)
  change_force()
end

function on_hit_water(cx, cy)
  px, py = get_pos()
  cx, cy = find_last_clear_point(cx, cy, px, py)
  set_pos(cx, cy)
  set_vel(0, 0)
  change_force()
end


function on_timer()
  set_timer(0.5 + 3 * my_random())
  change_force()
  if get_age() > 20 then
    if get_age() > 26 or my_random() < 0.3 then
      kill()
    end
  end
end

function change_force()
  x, y = get_dir_vector(my_random()*360)
  f = 2 + my_random() * 6
  set_force(f*x, f*y)

  px, py = get_pos()
  mx, my = get_map_pos(px, py)
  if terrain.is_water(get_map_type(mx, my)) then
    set_force(0, -5)
  end

  if terrain.is_sand(get_map_type(mx, my)) then
    set_pos(px, py-1)
  end

end

function write_data()
  write_int32(this.rnd)
end

function read_data()
  this.rnd = read_int32()
end

