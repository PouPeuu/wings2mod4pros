image = "grenade"
condition = 7.0
bounding_circle_radius = 2
hit_damage = 30
hit_impulse = 50
mass = 20.0
volume = 0.02
air_resistance = 1.0
send_reliably = true


function init(x_pos, y_pos, x_vel, y_vel, owner_id)
  px, py = get_object_pos(owner_id)
  vx, vy = get_object_vel(owner_id)
  px, py = find_last_clear_point(px, py, px+x_pos, py+y_pos)
  set_pos(px, py)
  set_vel(vx+x_vel, vy+y_vel)
  set_owner(owner_id)
end

function explode()
  radius = 20
  px, py = get_pos()
  mx, my = get_map_pos(px, py)
  t = get_map_type(mx, my)
  if terrain.is_strong(t) or terrain.is_indestructible(t) then
    radius = 8
  end
  create_object("collapser_effect", radius, get_id())
  kill()
end

function on_hit_ground(cx, cy)
  explode()
end

function on_hit_object(id)
  if get_object_max_condition(id) >= 20 then
    explode()
  end
end

function on_break()
  explode()
end



