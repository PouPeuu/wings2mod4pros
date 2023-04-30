required_objects = { "base_drop", "base_build" }

max_energy = 260
req_energy = 260

function launch()
  dir = get_platform_dir()
  dx, dy = get_dir_vector(dir)
  vx, vy = get_platform_vel()
  create_object("base_drop", 0, 8, -vx/4, -vy/4+80, get_platform_id())
end
