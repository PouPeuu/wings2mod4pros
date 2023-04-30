image = "infmine"
condition = 6.0
bounding_circle_radius = 3
hit_damage = 0
hit_impulse = 0
touch_damage = 0
mass = 20
volume = 0.29
air_resistance = 1
send_reliably = true
loop_animation = true
network_updates = true

function init(x_pos, y_pos, x_vel, y_vel, owner_id)
  px, py = get_object_pos(owner_id)
  vx, vy = get_object_vel(owner_id)
  px, py = find_last_clear_point(px, py, px+x_pos, py+y_pos)
  set_pos(px, py)
  set_vel(vx+x_vel, vy+y_vel)
  set_owner(owner_id)
  set_timer(0.3)
end

function on_timer()
  if attached_to_ground() then
    px, py = get_object_pos(get_id())
    mx, my = get_map_pos(px, py)
    support = false
    for tx = -1, 1 do
      for ty = -1, 1 do
        if not terrain.is_clear(get_map_type(mx+tx, my+ty)) then
          support = true
          break
        end
      end
    end
    if not support then
      attach_to_ground(0)
    end
  end
  network_update(1)
  set_timer(0.3)
end


function on_hit_ground(cx, cy)
  if attached_to_ground() then
    return
  end
  px, py = get_pos()
  cx, cy = find_last_clear_point(cx, cy, px, py)
  set_pos(cx, cy)
  set_vel(0, 0)
  attach_to_ground(1)
  set_animation("infmine")
  objects = get_objects_from(cx, cy, 2)
  for key, obj in ipairs(objects) do
    kill_landmine(key, obj)
  end
end

function kill_landmine(key, id)
  if get_object_type(id) == "infmineobj" and id ~= get_id() then
    kill_object(id)
  end
end

function explode()
  px, py = get_object_pos(owner_id)
  create_object("small_explosion", px + 5, py + 5 , 0, 0)
  kill()
end
  
function on_break()
  explode()
end

function on_hit_object(id)
  if attached_to_ground() then
    if get_object_mass(id) > 20 then
      if get_object_type(id) == "trooper" then
        kill_object(id)
      end
      explode()
    end
  end
end
