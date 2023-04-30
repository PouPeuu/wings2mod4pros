-- Floating particles that explode when shot at. Try for the domino effect.
-- Created 2004-03-06 by Sami

required_objects = { "nucleus" }

max_energy = 600
req_energy = 13
req_energy_level = 40
delay = 0.12
limited_object = "nucleus"
limit = 200

function launch()
  create_object("nucleus", 0, 0, get_platform_id())
end
