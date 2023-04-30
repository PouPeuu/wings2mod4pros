animation = "fshield"
loop_animation = true
has_dir = true

lifetime = 12
air_resistance = 30
mass = 10
volume = 0.5

condition = 0
bounding_circle_radius = 17
check_hits = true

hit_damage = 0
hit_impulse = 0
touch_damage = 0

remote_callbacks = true
send_reliably = true

function init(x_pos, y_pos, dir, owner_id)
  set_pos(x_pos, y_pos)
  set_dir(dir)
  attach_to(owner_id)
  set_owner(owner_id)
  set_timer(0.05)
  this.energy = 6000
end

function network_init()
  this.energy = 6000
end

function on_timer()
  id = get_attached_object()
  if is_alive(id) then
    dir = get_object_dir(id)
    set_dir(dir)
    set_timer(0.05)
  else
    kill()
  end
end

function on_hit_ground(cx, cy)
  set_pos(cx, cy)
end

function on_hit_object(id)
  owner = get_attached_object()
  if not is_alive(owner) then return end
  if get_object_type(id) == "emp" then return end
  if get_object_type(id) == "fshield" then return end
  if get_object_type(id) == "gravity_obj" then return end
  if get_object_type(id) == "wave_particle_3" then return end
  if get_object_type(id) == "wormhole_end" then return end
  if get_object_type(id) == "wormhole_start" then return end
  if get_object_type(id) == "plasma" then return end

  if get_object_type(id) == "pulse" then
    this.energy = this.energy - 2000
  end
  if get_object_type(id) == "tb_object" then
    this.energy = this.energy - 10000
  end


  m = get_object_mass(id)
  if m > 90 then return end

  dir = get_object_dir(owner)
  sx, sy = get_object_vel(owner)
  ownermass = get_object_mass(owner)

  x, y = get_pos()
  ox, oy = get_object_pos(id)
  d = distance(x, y, ox, oy)
  if d < 4 then return end

  tx = ox - x
  ty = oy - y
  tdir = get_vector_dir(tx, ty)
  dc = dir_change(dir, tdir)
  if math.abs(dc) > 45 then return end

  rx = ty
  ry = -tx
  rd = rx*rx + ry*ry
  ovx, ovy = get_object_vel(id)
  vx = ovx - sx
  vy = ovy - sy

  vdir = get_vector_dir(vx, vy)
  dc = dir_change(dir, vdir)
  if math.abs(dc) < 90 then return end

  rdv = rx * vx + ry * vy
  if rdv < 0 then
    rx = -rx
    ry = -ry
    rdv = -rdv
  end
  px = rx * rdv / rd
  py = ry * rdv / rd
  dx = px - vx
  dy = py - vy
 
  dd = math.sqrt(dx*dx + dy*dy)
  if m > 0 then
    impulse = m * dd
  else
    impulse = 0
  end

  c = get_object_max_condition(id)
  if is_solid(id) and c >= 3.0 and c <= 15.0 then
    cause_damage(id, c+1)
    impulse = 0.5 * impulse
  else
    set_object_vel(id, vx + 2 * dx, vy + 2 * dy)
  end
  
  if dd > 0.1 then
    ix = - 10 * impulse * dx / dd
    iy = - 10 * impulse * dy / dd
    p = math.sqrt(ix*ix + iy*iy)
    if p > 20000 then
      a = 20000 / p
      ix = ix * a
      iy = iy * a
    end
    
    add_object_impulse(owner, ix, iy)
  end

  if impulse < 2500 then
    this.energy = this.energy - impulse
  else
    this.energy = this.energy - 2500
  end
  if this.energy <= 0 then kill() end

end


