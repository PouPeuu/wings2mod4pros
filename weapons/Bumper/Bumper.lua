-- Bumps everything away. Thanks to DiCola for the idea and graphics.
-- Created 2005-05-28 by Sami

required_objects = { "bumper" }

max_energy = 750
req_energy = 150
delay = 0.2
limited_object = "bumper"
limit = 20

function launch()
  create_object("bumper", 0, 0, get_platform_id())
end

