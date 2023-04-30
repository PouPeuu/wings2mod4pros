-- Wave particle for windstrike
-- Created 2004-06-05 by Sami

-- animation = "wave_particle_3"
-- loop_animation = false
image = "wind"

lifetime = 0.7

air_resistance = 0.5
mass = 0.05
volume = 0.05

bounding_circle_radius = 25
hit_damage = 0
hit_impulse = 0
touch_damage = 0

check_hits = true
can_hit_same_type = false
remote_callbacks = true
remote_check_hits = true

function init(x_pos, y_pos, x_vel, y_vel, owner_id)
  px, py = get_object_pos(owner_id)
  vx, vy = get_object_vel(owner_id)
  px, py = find_last_clear_point(px, py, px+x_pos, py+y_pos)
  set_pos(px, py)
  set_vel(vx+x_vel, vy+y_vel)
  set_owner(owner_id)
end

function on_hit_water(cx, cy)
  vx, vy = get_vel()
  create_object("smoke", 0, 0, -vx, -100-vy, 150, 150, 150, 0.2)
  kill()
end

function on_hit_object(id)
  if get_object_type(id) == "fshield" then return end
  s = get_object_size(id)
  i = 0.5*s*s*s
  if i / get_object_mass(id) > 7 then i = 7 * get_object_mass(id) end
  vx, vy = get_vel()
  vx2, vy2 = get_object_vel(id)
  vx = vx - vx2
  vy = vy - vy2
  add_object_force(id, i*vx, i*vy)
end
