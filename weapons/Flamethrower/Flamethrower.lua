-- Flame-thrower - do we need to say more?
-- Created 2004-04-25 by Sami

required_objects = { "smallflame" }

max_energy = 220
req_energy = 1.45
req_energy_level = 35
delay = 0.02
recoil = 100
speed = 170

function launch()
  dir = get_platform_dir()

  dir = dir + (8 * (math.random() - 0.5))
  dx, dy = get_dir_vector(dir)
  create_object("smallflame", dx*9, dy*9, speed*dx, speed*dy, get_platform_id())

  dir = dir + (4 * (math.random() - 0.5))
  dx, dy = get_dir_vector(dir)
  create_object("smallflame", dx*11, dy*11, speed*dx, speed*dy, get_platform_id())
  
end
