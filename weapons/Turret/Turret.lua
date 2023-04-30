required_objects = { "turret", "turret_gun", "fragment", "emp_effect", "freezer_effect" }

max_energy = 260
req_energy = 260
limited_object = "turret"
limit = 5

function launch()
  dir = get_platform_dir()
  dx, dy = get_dir_vector(dir)
  vx, vy = get_platform_vel()
  id = create_object("turret", dx*8, dy*8, 180*dx, 180*dy, dir, get_platform_id())
  create_object("turret_gun", id, get_platform_id())
end
