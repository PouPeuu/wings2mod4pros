animation = "pulse"
lifetime = 0.5
bounding_circle_radius = 5*54
hit_ground = false
send_reliably = true
static = true


function init(x_pos, y_pos, x_vel, y_vel, owner_id)
  px, py = get_object_pos(owner_id)
  vx, vy = get_object_vel(owner_id)
  set_pos(px+x_pos, py+y_pos)
  set_vel(vx+x_vel, vy+y_vel)
  set_owner(owner_id)
  EMP_hit(owner_id, 20)
end


function on_hit_object(id)
  px, py = get_pos()
  ox, oy = get_object_pos(id)
  dist = math.sqrt((px-ox)^2 + (py-oy)^2)
  rad = 2 + (get_age() * (bounding_circle_radius-2) / lifetime)
  if dist <= rad then 
    EMP_hit(id, 3)
  end
end

