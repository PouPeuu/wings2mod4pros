-- Sprays blocks of concrete that create hard wall when hit upon ground
-- Created 2006-03-04 by Sami

required_objects = { "concrete" }

short_name = "Concrete"
max_energy = 250
req_energy = 0.75
delay = 0.02


function launch()
  dir = get_platform_dir()
  dir = dir + (16 * (math.random() - 0.5))
  dx, dy = get_dir_vector(dir)
  id = create_object("concrete", dx*3, dy*3, dx*180, dy*180, get_platform_id())
end
