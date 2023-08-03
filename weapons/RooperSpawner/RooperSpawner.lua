required_objects = { "rooperSpawner_drop", "rooperSpawner_build", "rooperSpawner" }

max_energy = 1000
req_energy = 1000

function launch()
  dir = get_platform_dir()
  dx, dy = get_dir_vector(dir)
  vx, vy = get_platform_vel()
  create_object("rooperSpawner_drop", 0, 8, -vx/4, -vy/4+80, get_platform_id())
end
