-- Anti-Aircraft Missile
-- Created 2005-05-21 by Sami

required_objects = { "aamissile" }

max_energy = 80
req_energy = 80

function launch()
  dir = get_platform_dir()
  dx, dy = get_dir_vector(dir)
  create_object("aamissile", dx*8, dy*8, dx*80, dy*80, dir, get_platform_id())
end
