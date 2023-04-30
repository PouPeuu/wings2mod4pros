-- Fires a glowing plasma ball
-- Created 2005-04-19 by Sami (animation by DiCola)

required_objects = { "plasma" }

max_energy = 65
req_energy = 65
recoil = 5000

function init()
end

function launch()
  dx, dy = get_dir_vector(get_platform_dir())
  create_object("plasma", dx*8, dy*8, dx*160, dy*160, get_platform_id())
end
