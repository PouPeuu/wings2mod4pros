animation = "base_build"
image_x = 0
image_y = -6
condition = 25.0
bounding_circle_radius = 6
mass = 100.0
volume = 1
static = true
lifetime = 0.5

function init(x_pos, y_pos, owner_id)
  px, py = find_last_clear_point(x_pos, y_pos-1, x_pos, y_pos+1)
  mx, my = get_map_pos(px, py)
  px, py = get_world_pos(mx, my)
  set_pos(px, py)
  set_owner(owner_id)
end


function make_base(x, y, r, g, b)
  t = get_map_type(x, y)
  if not terrain.is_indestructible(t) then
    set_map_pixel(x, y, terrain.Base, r, g, b, 255)
  end
end

function on_lifetime_end()
  mx, my = get_map_pos_rel(0, 0)
  y = 0
  make_base(mx-7, my+y, 167, 167, 167)
  make_base(mx+6, my+y, 167, 167, 167)
  for x = -6,5 do
    make_base(mx+x, my+y, 119, 119, 119)
  end
  y = -1
  for x = -6,5 do
    make_base(mx+x, my+y, 167, 167, 167)
  end
end

