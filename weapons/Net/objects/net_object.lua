image = "net_object"
condition = 20.0
bounding_circle_radius = 3
hit_damage = 0
hit_impulse = 0
touch_damage = 0
mass = 20.0
volume = 0.2
solidity = 0.5
air_resistance = 300.0
speed_limit = 400.0
can_hit_same_type = false
lifetime = 15
ground_kills = false
send_reliably = true
network_updates = true
poison_effect = 0.05


attached_objects = {}

function init(x_pos, y_pos, x_vel, y_vel, ground, net_id, owner_id)
  px, py = get_object_pos(owner_id)
  vx, vy = get_object_vel(owner_id)
  px, py = find_last_clear_point(px, py, px+x_pos, py+y_pos)
  set_pos(px, py)
  set_vel(vx+x_vel, vy+y_vel)
  set_owner(owner_id)
  set_timer(0.05 + 0.2*math.random())
  this.net_id = net_id
  attached_objects[this.net_id] = {}
  network_init()
  this.ground = ground
  this.network_time = 0
end

function network_init()
  this.emp_effect = 0
  this.emp_effect_time = 0
  this.ground = 0
  this.network_time = 0
end

function write_data()
  write_int32(this.net_id)
  write_int8(this.ground)
end

function read_data()
  this.net_id = read_int32()
  attached_objects[this.net_id] = {}
  this.ground = read_int8()
end

function on_timer()

  px, py = get_pos()
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
  if not support and get_attached_object() == 0 then
    attach_to(0)
  end
  
  fx, fy = get_force()
  if distance(0, 0, fx, fy) > 50000 and get_attached_object() == 0 then
    attach_to(0)
  end

  network_update(1)
  set_timer(0.2)

end

function on_hit_object(id) 
  if is_solid(id) and attached_objects[this.net_id][id] ~= true and get_attached_object() == 0 then
    attach_to(id)
    attached_objects[this.net_id][id] = true
  end
end

function on_hit_ground(cx, cy)
  x, y = get_pos()
  cx, cy = find_last_clear_point(cx, cy, x, y)
  set_pos(cx, cy)
  if this.ground == 1 then
    attach_to_ground(1)
  end
  if this.ground == 2 then
    vx, vy = get_vel()
    set_vel(-0.7*vx, -0.7*vy)
  else
    vx, vy = get_vel()
    set_vel(-0.25*vx, -0.25*vy)
  end

  if get_time() > this.network_time + 0.2 then
    network_update(2)
    this.network_time = get_time()
  end
end

