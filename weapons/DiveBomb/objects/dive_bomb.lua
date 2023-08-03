image = "dive_bomb"
bounding_circle_radius = 2
hit_damage = 7
hit_impulse = 40
mass = 50.0
volume = 10.0
air_resistance = 1000.0

function face_vel_dir()
  set_dir(get_vector_dir(get_vel()))
end

function init(x_pos, y_pos, x_vel, y_vel, owner_id)
  px, py = get_object_shoot_pos(owner_id)
  vx, vy = get_object_vel(owner_id)
  px, py = find_last_clear_point(px, py, px+x_pos, py+y_pos)
  set_pos(px, py)
  set_vel(vx/3+x_vel, vy+y_vel)
  set_owner(owner_id)
  face_vel_dir()
end

function run_simulation()
  face_vel_dir()
end

function explode()
  create_object("big_explosion", 0, 0, 0, 0)
  kill()
end

function on_hit_ground(cx, cy)
  set_pos(cx, cy)
  explode()
end

function on_hit_object(id)
  if get_object_max_condition(id) >= 20 then
    set_vel(0, 0)
    explode()
  end
end
