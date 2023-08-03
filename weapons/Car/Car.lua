required_objects = { "car", "wheel" }

max_energy = 50
req_energy = 50

function launch()
  dir = get_platform_dir()
  dx, dy = get_dir_vector(dir)
  vx, vy = get_platform_vel()
  car = create_object("car",0,0,0,0,get_platform_id())
  wheel1 = create_object("wheel", car, 11, 4, get_platform_id())
  wheel2 = create_object("wheel", car, -12, 4, get_platform_id())
end