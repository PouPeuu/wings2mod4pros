-- A front shield for the ship.
-- Created 2006-03-05 by Sami

required_objects = { "fshield" }

max_energy = 170
req_energy = 170

function launch()
  px, py = get_platform_pos()
  dir = get_platform_dir()
  id = create_object("fshield", px, py, dir, get_platform_id())
  set_wait_object(id)
end
