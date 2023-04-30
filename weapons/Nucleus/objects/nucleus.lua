animation = "nucleus"
condition = 3.0
bounding_circle_radius = 3
hit_damage = 0
hit_impulse = 0
touch_damage = 0
mass = 2.0
volume = 1.6
air_resistance = 1.0
can_hit_same_type = false

speed = 220;

function init(x_pos, y_pos, owner_id)
  px, py = get_object_pos(owner_id)
  px, py = find_last_clear_point(px, py, px+x_pos, py+y_pos)
  set_pos(px, py)
  set_vel(0, 0)
  set_owner(owner_id)
  attach_to_ground(true)
  set_timer(0.2)
end

function on_timer()
  team = get_object_team(get_id())
  x, y = get_pos()
  objs = get_objects_from(x, y, 20)
  for index, obj in pairs(objs) do
    if obj ~= get_id() then

      if get_object_type(obj) == "nucleus" then
        tx, ty = get_object_pos(obj)
        if distance(x, y, tx, ty) < 5 then
          kill()
          return
        end
      end
      
      c = get_object_max_condition(obj)
      if c >= 8 and get_object_team(obj) ~= team and get_object_type(obj) ~= "flag" then
        tx, ty = get_object_pos(obj)
        if check_LOS(x, y, tx, ty, 2) then
          explode()
          kill()
        end
      end
    end
  end
  set_timer(0.2)
end

function explode()
  create_object("nucleus_explosion", 0, 0, 0, 0)
end

function on_hit_ground(cx, cy)
  px, py = get_pos()
  cx, cy = find_last_clear_point(cx, cy, px, py)
  set_pos(cx, cy)
  set_vel(0, 0)
end

function on_break()
  explode()
end

function check_LOS(x1, y1, x2, y2, rad)
  lx, ly = find_first_solid_point(x1, y1, x2, y2)
  if distance(lx, ly, x2, y2) > rad then return false end
  
  team = get_object_team(get_id())
  objs = get_objects_from_line(x1, y1, x2, y2, rad)
  for index, obj in pairs(objs) do
    if obj ~= get_id() and obj ~= this.turret_id then
      c = get_object_max_condition(obj)
      if c >= 8 and get_object_team(obj) == team then
        return false
      end
    end
  end
  return true
end
