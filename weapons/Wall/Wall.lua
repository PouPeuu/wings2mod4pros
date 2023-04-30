required_objects = { "wall_builder" }

max_energy = 200
req_energy = 200

function launch()
  dir = get_platform_dir()
  dx, dy = get_dir_vector(dir)
  vx, vy = get_platform_vel()
  create_object("wall_builder", dx*8, dy*8, 250*dx, 250*dy, dir, get_platform_id())
end
