image = "bomb"
condition = 12.0
bounding_circle_radius = 3
hit_damage = 10
hit_impulse = 70
touch_damage = 0
mass = 80.0
volume = 5.0
air_resistance = 800.0

color_r = 190;
color_g = 190;
color_b = 190;
splint_speed = 100;
dirt_speed = 80;

function init(x_pos, y_pos, x_vel, y_vel, owner_id)
  px, py = get_object_pos(owner_id)
  vx, vy = get_object_vel(owner_id)
  px, py = find_last_clear_point(px, py, px+x_pos, py+y_pos)
  set_pos(px, py)
  set_vel(vx+x_vel, vy+y_vel)
  set_owner(owner_id)
end

function explode()
  create_object("small_explosion", 0, 0, 0, 0)
end

function on_hit_ground(cx, cy)
  px, py = get_pos()
  cx, cy = find_last_clear_point(cx, cy, px, py)
  set_pos(cx, cy)
  set_vel(0, 0)
  kill()
  mx, my = get_map_pos(px, py)
  t1 = get_map_type(mx, my)
  if (t1 >= 4 and t1 <= 18) or t1 == 132 then
    r, g, b, a = get_map_color(mx, my)
    remove_map_pixel(mx, my)
    for i = 0,10 do
      speed = dirt_speed * 0.5 * (math.random() + math.random())
      dir = math.random(300) - 150
      dx, dy = get_dir_vector(dir)
      x_vel = speed * dx
      y_vel = speed * dy
      create_object("particle", 0, 0, x_vel, y_vel, r, g, b, 1, true, 10, 0)
    end
  end
  explode()
end

function on_hit_object(id)
  type = get_object_type(id)
  if get_object_max_condition(id) >= 20 then
    set_vel(0, 0)
    kill()
    explode()
  end
end

function on_break()
  explode()
end
