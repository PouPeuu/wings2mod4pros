-- Flame-thrower - do we need to say more?
-- Created 2004-04-25 by Sami
-- 28.02.2006: Modified to Welder by JJ45

required_objects = { "blueflame" }

max_energy = 1
req_energy = 1
req_energy_level = 1
delay = 0
recoil = 100
speed = 200

function launch()
  dir = get_platform_dir()

  dir = dir
  dx, dy = get_dir_vector(dir)
  create_object("blueflame", dx*5, dy*5, speed*dx, speed*dy, get_platform_id())
  create_object("blueflame", dx*4, dy*4, speed*dx, speed*dy, get_platform_id())
  create_object("blueflame", dx*3, dy*3, speed*dx, speed*dy, get_platform_id())
  create_object("blueflame", dx*2, dy*2, speed*dx, speed*dy, get_platform_id())
  
end
