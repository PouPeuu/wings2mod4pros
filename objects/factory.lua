animation = "factory"
hit_animation = "factory_hit"
mass = 10000.0
condition = 2000
volume = 64
air_resistance = 2000.0
bounding_circle_radius = 15
ground_kills = false
static = true
network_updates = true
send_reliably = true
show_condition = true


function init(x_pos, y_pos, x_vel, y_vel, team)
  set_pos(x_pos, y_pos)
  set_vel(0, 0)
  set_team(team)
  set_timer(0.5)
  network_init()
end

function network_init()
  this.last_condition = 2000
end


function damage_points()
  if get_condition() < this.last_condition-20 then
    t = 1
    if get_team() == 1 then t = 2 end
    p = math.floor((this.last_condition+20 - get_condition()) / 20)
    add_team_points(t, p)
    this.last_condition = this.last_condition - p*20
  end
end


function on_hit_object(id)
  if get_object_type(id) == "nucleus" then
    kill_object(id)
  end

  if get_object_type(id) == "gas" then
    x, y = get_pos()
    ox, oy = get_object_pos(id)
    if ox == x and oy == y then oy = y - 1 end
    d = distance(x, y, ox, oy)
    tx = ox - x
    ty = oy - y
    new_x = ox + 2 * tx / d
    new_y = oy + 2 * ty / d
    mx, my = get_map_pos(new_x, new_y)
    if terrain.is_clear(get_map_type(mx, my)) then
      set_object_pos(id, new_x, new_y)
    else
      kill_object(id)
    end
  end

  if get_object_type(id) == "bumper" then
    x, y = get_pos()
    ox, oy = get_object_pos(id)
    if ox == x and oy == y then oy = y - 1 end
    d = distance(x, y, ox, oy)
    tx = ox - x
    ty = oy - y
    new_x = ox + 2 * tx / d
    new_y = oy + 2 * ty / d
    set_object_pos(id, new_x, new_y)
  end
  
  if get_object_type(id) == "grid_point" then
    kill_object(id)
  end

  if get_object_type(id) == "wormhole_start" then
    call_object(id)
  end

  if get_object_type(id) == "wormhole_end" then
    call_object(id, 0)
  end

end


function on_timer()

  damage_points()

  team = get_object_team(get_id())
  x, y = get_pos()
  objs = get_objects_from(x, y, 24)
  for index, obj in pairs(objs) do
    if obj ~= get_id() then
      c = get_object_max_condition(obj)
      if c >= 8 and get_object_team(obj) ~= team then
        cause_damage(obj, 5)
      end
    end
  end

  px, py = get_pos()
  mx, my = get_map_pos(px, py)
  for y = -2, 5 do
    k = -9
    if y < 1 then k = 2 end
    for x = k, 9 do
      if not terrain.is_clear(get_map_type(mx+x, my+y)) then
        remove_map_pixel(mx+x, my+y)
      end
    end
  end

  set_timer(0.5)
end


function on_break()
  damage_points()
  x, y = get_pos()
  create_object("factory_obj2", x, y, get_team())
end


function write_data()
  write_int32(this.o2)
end

function read_data()
  this.o2 = read_int32()
end
