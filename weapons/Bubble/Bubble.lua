required_objects = { "bubble" }

max_energy = 30
req_energy = 30


function launch()
  dir = get_platform_dir()
  dx, dy = get_dir_vector(dir)
  id = create_object("bubble", dx*10, dy*10, 240*dx, 240*dy, get_platform_id())
end

