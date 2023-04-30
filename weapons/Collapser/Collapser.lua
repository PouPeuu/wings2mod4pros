required_objects = { "collapser", "collapser_effect" }

max_energy = 200
req_energy = 200

function launch()
  dir = get_platform_dir()
  dx, dy = get_dir_vector(dir)
  create_object("collapser", dx*8, dy*8, 280*dx, 280*dy, get_platform_id())
end
