image = "grenade"
condition = 7.0
bounding_circle_radius = 2
hit_damage = 7
hit_impulse = 40
mass = 20.0
volume = 0.02
air_resistance = 1.0


function init(x_pos, y_pos, x_vel, y_vel, owner_id)
  px, py = get_object_shoot_pos(owner_id)
  vx, vy = get_object_vel(owner_id)
  px, py = find_last_clear_point(px, py, px+x_pos, py+y_pos)
  set_pos(px, py)
  set_vel(vx+x_vel, vy+y_vel)
  set_owner(owner_id)
end

function explode()
  create_object("small_explosion", 0, 0, 0, 0)
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

function on_break()
  explode()
end
