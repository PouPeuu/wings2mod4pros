required_objects = { "gasmineobj", "minegas" }

max_energy = 160
req_energy = 160

function launch()
  vx, vy = get_platform_vel()
  dir1 = get_platform_dir()+5
  dir2 = get_platform_dir()-5
  a = 5*1.3
  for n=0,1 do
    dx1, dy1 = get_dir_vector(dir1)
    dx2, dy2 = get_dir_vector(dir2)
    create_object("gasmineobj", dx1*9, dy1*9, dx1*a*(14+2*n), dy1*a*(14+2*n), get_platform_id())
    create_object("gasmineobj", dx2*9, dy2*9, dx2*a*(14+2*n), dy2*a*(14+2*n), get_platform_id())
    dir1=dir1+10
    dir2=dir2-10
  end

  dir1 = get_platform_dir()+5
  dir2 = get_platform_dir()-5
  for n=0,1 do
    dx1, dy1 = get_dir_vector(dir1)
    dx2, dy2 = get_dir_vector(dir2)
    create_object("gasmineobj", dx1*9, dy1*9, dx1*a*(10+2*n), dy1*a*(10+2*n), get_platform_id())
    create_object("gasmineobj", dx2*9, dy2*9, dx2*a*(10+2*n), dy2*a*(10+2*n), get_platform_id())
    dir1=dir1+10
    dir2=dir2-10
  end

end

