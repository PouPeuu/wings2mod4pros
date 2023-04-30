required_objects = { "rocket" }

max_energy = 85
req_energy = 85

function launch()
  dir = get_platform_dir()
  dx, dy = get_dir_vector(dir)
  create_object("rocket", dx*8, dy*8, dx*80, dy*80, dir, get_platform_id())
end
