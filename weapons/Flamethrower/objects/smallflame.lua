-- Flame particle for flame-thrower
-- Created 2004-04-25 by Sami

animation = "smallflame"
loop_animation = false

lifetime = 0.6

air_resistance = 0.5
mass = 0.05
volume = 0.05

bounding_circle_radius = 2
hit_damage = 0.725
hit_impulse = 1
touch_damage = 0.155


function burn(t, mx, my)
  r, g, b, a = get_map_color(mx, my)

  if t == terrain.Normal or t == terrain.Sand or t == terrain.NoFrictionNoDamage or 
     t == terrain.NonDamaging or t == terrain.NoFriction or t == terrain.Mud then

    if math.random(8) == 1 then
      remove_map_pixel(mx, my)
    else
      rm = 60
      r = math.max(0, math.min(0.4*(r + rm), 255))
      g = math.max(0, math.min(0.4*(g + rm), 255))
      b = math.max(0, math.min(0.4*(b + rm), 255))
      set_map_pixel(mx, my, t, r, g, b, a)
    end

  elseif terrain.is_strong(t) or terrain.is_indestructible(t) then
    rm = (r+b+g)/3
    if rm < 60 then rm = 0.2 * rm
    else rm = 0.2 * (rm - 10) end
    r = math.max(0, math.min(0.8*r + rm, 255))
    g = math.max(0, math.min(0.8*g + rm, 255))
    b = math.max(0, math.min(0.8*b + rm, 255))
    set_map_pixel(mx, my, t, r, g, b, a)

  elseif t == terrain.Ice or t == terrain.Snow then
    set_map_pixel(mx, my, 128, r, g, b, a)

  elseif t == terrain.Flammable then
    fire(mx, my)

  elseif t == terrain.Explosive or t == terrain.PlasticExplosive then
    explode(mx, my)
  end
end

function init(x_pos, y_pos, x_vel, y_vel, owner_id)
  px, py = get_object_shoot_pos(owner_id)
  vx, vy = get_object_vel(owner_id)
  px, py = find_last_clear_point(px, py, px+x_pos, py+y_pos)
  set_pos(px, py)
  set_vel(vx+x_vel, vy+y_vel)
  set_owner(owner_id)
end

function on_hit_ground(cx, cy)
  px, py = get_pos()

  mx, my = get_map_pos(px, py)
  t = get_map_type(mx, my)
  burn(t, mx, my)

  cx, cy = find_last_clear_point(cx, cy, px, py)
  set_pos(cx, cy)
  set_vel(0, 0)
  sdir = 0
  for n=0,1 do
    sx, sy = get_dir_vector(sdir)
    col = 180 + math.random(75)
    lt = 0.1 + 0.1 * math.random(4)
    create_object("smoke", 0, 0, 80*sx, 80*sy, 0.6*col, 0.6*col, 0.6*col, lt)
    sdir=sdir+120
  end
  kill()
end

function on_hit_water(cx, cy)
  vx, vy = get_vel()
  create_object("smoke", 0, 0, -vx, -100-vy, 150, 150, 150, 0.5)
  kill()
end

function on_hit_object(id)
  if is_solid(id) then
    kill()
  end
end
