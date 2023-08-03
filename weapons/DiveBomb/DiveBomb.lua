required_objects = { "dive_bomb" }

max_energy = 100
req_energy = 100

function launch()
  dx, dy = get_dir_vector(get_platform_dir())
  create_object("dive_bomb", 0, 0, 0, 0, get_platform_id())
end

