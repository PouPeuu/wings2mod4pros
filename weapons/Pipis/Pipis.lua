required_objects = { "pipis" }

max_energy = 500
req_energy = 500

function launch()
  dir = get_platform_dir()
  dx, dy = get_dir_vector(dir)
  create_object("pipis", dx*8, dy*8, dx*80, dy*80, dir, get_platform_id())
end
