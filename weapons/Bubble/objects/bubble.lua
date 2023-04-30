animation = "bubble"
loop_animation = false
lifetime = 10
air_resistance = 8000.0
mass = 50.0
volume = 375.0
condition = 20.0
bounding_circle_radius = 13
shoot_from_inside = false
hit_damage = 0
hit_impulse = 0
touch_damage = 0
ground_kills = false
network_updates = true
send_reliably = true

function init(x_pos, y_pos, x_vel, y_vel, owner_id)
  px, py = get_object_pos(owner_id)
  vx, vy = get_object_vel(owner_id)
  px, py = find_last_clear_point(px, py, px+x_pos, py+y_pos)
  set_pos(px, py)
  set_vel(vx+x_vel, vy+y_vel)
  set_owner(owner_id)
end


function on_hit_object(id)
  if get_attached_object() == 0 and 
     get_object_type(id) ~= get_type() and 
     is_solid(id) 
  then
    attach_to(id)
    network_update(2)
  end
end

