animation = "rooperSpawner_build"
condition = 25.0
bounding_circle_radius = 6
mass = 100.0
volume = 1
static = true
lifetime = 1

function init(x_pos, y_pos, owner_id)
  px, py = find_last_clear_point(x_pos, y_pos-1, x_pos, y_pos+1)
  mx, my = get_map_pos(px, py)
  px, py = get_world_pos(mx, my)
  set_pos(px, py)
  set_owner(owner_id)
end

function on_lifetime_end()
  create_object("rooperSpawner",0,0,get_owner())
end