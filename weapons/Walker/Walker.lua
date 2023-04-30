max_energy = 340
req_energy = 340

function launch()
  dir = get_platform_dir()
  dx, dy = get_dir_vector(dir)
  vx, vy = get_platform_vel()
  create_object("walker", 0, -8, -vx/4, -vy/4+80)
end

