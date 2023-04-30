animation = "plasma"
loop_animation = true
send_reliably = true

lifetime = 60
air_resistance = 0.5
mass = 1.25
volume = 1

bounding_circle_radius = 8

hit_damage = 0
hit_impulse = 0
touch_damage = 180

network_updates = true

function init(x_pos, y_pos, x_vel, y_vel, owner_id)
  px, py = get_object_pos(owner_id)
  vx, vy = get_object_vel(owner_id)
  px, py = find_last_clear_point(px, py, px+x_pos, py+y_pos)
  set_pos(px, py)
  set_vel(vx+x_vel, vy+y_vel)
  set_owner(owner_id)
  set_timer(0.05)
  this.cond = 9000
end

function network_init()
  this.cond = 9000
end


function on_timer()
  if this.cond > 0 then
    px, py = get_pos()
    mx, my = get_map_pos(px, py)
    fillCircle(mx, my, 4)
    set_timer(0.05)
  else 
    kill()
  end
end


function on_hit_object(id)
  this.cond = this.cond - get_dt() * 2250
  m = get_object_mass(id)
  if m > 20 then
    this.cond = this.cond - get_dt() * 22500
  end
end


function on_hit_ground(cx, cy)
  set_pos(cx, cy)
end

function fillCircle(xCenter, yCenter, radius)
  r2 = radius * radius
  fillXLine(xCenter - radius, xCenter + radius, yCenter)
  for y = 1, radius do
    x = math.sqrt(r2 - y * y)
    fillXLine(xCenter - x, xCenter + x, yCenter + y)
    fillXLine(xCenter - x, xCenter + x, yCenter - y)
  end
end

function fillXLine(xmin, xmax, y)
  for i = xmin, xmax do
    makePoint(i, y)
  end
end




function makePoint(x, y)
  px, py = get_pos()
  vx, vy = get_vel()
  mx, my = get_world_pos(x, y)
  dx = mx - px
  dy = my - py
  t = get_map_type(x, y)

  if terrain.is_clear(t) then 
    this.cond = this.cond - 1;
  elseif terrain.is_water(t) then 
    set_map_pixel(x, y, 0, 0, 0, 0, 0)
    this.cond = this.cond - 9
    if math.random(4) == 1 then
      create_object("smoke", dx, dy, -vx, -100-vy, 150, 150, 150, 0.5)
    end
  elseif t == terrain.Ice or terrain.is_snow(t) then
    set_map_pixel(x, y, terrain.Water, 0, 0, 0, 0)
    this.cond = this.cond - 9
    if math.random(4) == 1 then
      create_object("smoke", dx, dy, -vx, -100-vy, 150, 150, 150, 0.5)
    end
  elseif t == terrain.Flammable then
    this.cond = this.cond - 150
    fire(x, y)
  elseif t == terrain.Explosive or t == terrain.PlasticExplosive then
    this.cond = this.cond - 150
    explode(x, y)
  elseif t == terrain.Normal or terrain.is_sand(t) or 
         t == terrain.NoFrictionNoDamage or 
         t == terrain.NoFrictionNoDamageIndestr or t == terrain.Soft or
         t == terrain.NonDamaging or t == terrain.NoFriction or t == terrain.Mud then 
    this.cond = this.cond - 150
    remove_map_pixel(x, y)
  elseif t == terrain.Hard then 
    this.cond = this.cond - 7000
    remove_map_pixel(x, y)
  else -- indestructible and base
    this.cond = this.cond - 50
--    kill()
  end
end

