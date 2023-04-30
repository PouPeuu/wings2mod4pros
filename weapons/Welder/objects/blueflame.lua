-- Flame particle for flame-thrower
-- Created 2004-04-25 by Sami
-- 28-02-2006: Modified to welder flame particle by JJ45 

animation = "blueflame"
loop_animation = false

lifetime = 0.1

air_resistance = 0.1
mass = 0.05
volume = 0.05

bounding_circle_radius = 2

function init(x_pos, y_pos, x_vel, y_vel, owner_id)
  px, py = get_object_pos(owner_id)
  vx, vy = get_object_vel(owner_id)
  px, py = find_last_clear_point(px, py, px+x_pos, py+y_pos)
  set_pos(px, py)
  set_vel(vx+x_vel, vy+y_vel)
  set_owner(owner_id)
end

function on_hit_ground(cx, cy)
  vx, vy = get_vel()
  kill()
end

function on_hit_water(cx, cy)
  vx, vy = get_vel()
  kill()
end

function on_hit_object(id)
  if is_solid(id) and not (get_object_type(id) == "trooper") and not (get_object_type(id) == "pilot") 
                  and not (get_object_type(id) == "factory") and not (get_object_type(id) == "glider") then
    cause_damage(id, -0.15)
    kill()
  else 
    if is_solid(id) then
      cause_damage(id, 0.5)
      kill()
    end
  end
end
