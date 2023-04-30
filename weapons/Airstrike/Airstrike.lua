-- Drops series of bombs.
-- Created 2005-05-22 by Sami

required_objects = { "small_bomb" }

load_mode = 2
req_energy = 160
num_shots = 8
shot_energy = 4

function launch()
  dir = get_platform_dir()
  dx, dy = get_dir_vector(dir)
  create_object("small_bomb", 0, 0, 0, 120, get_platform_id())
end
