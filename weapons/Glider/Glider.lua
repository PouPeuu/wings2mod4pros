max_energy = 40
req_energy = 40

function launch()
  set_energy(0)
  dir = get_platform_dir()
  dx, dy = get_dir_vector(dir)
  vx, vy = get_platform_vel()
  d = 0
  if dir >= 0 and dir < 180 then d = 90
  else d = 270 end
  id = create_object("glider", 0, -2, 0, 0, d)
  enter_object(get_platform_id(), id)
end

