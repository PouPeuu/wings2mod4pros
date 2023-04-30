
max_energy = 110
req_energy = 110
recoil = 0


function launch()
  dir = get_platform_dir()
  dx, dy = get_dir_vector(dir)
  
  dir_left = dir - 90
  dir_right = dir + 90
  lx, ly = get_dir_vector(dir_left)
  rx, ry = get_dir_vector(dir_right)
  
  id1 = create_object("dumbfire", lx*18, ly*18, dx*140+dx*70, dy*140+dy*70)
  id2 = create_object("dumbfire", rx*18, ry*18, dx*140+dx*-70, dy*140+dy*-70)
  create_object("rope", 1, 10, id1, id2)
end

