max_energy = 3
req_energy = 3
recoil = 0

function can_dig(type)
  return terrain.is_solid(t) and not terrain.is_indestructible(t)
--           not terrain.is_strong(t) and 
end


function launch()
  dir = get_platform_dir()
  dx, dy = get_dir_vector(dir)
  
  dir_left = dir - 90
  lx, ly = get_dir_vector(dir_left)
  
  m = 2
  
  for k = 0, 6, 1 do
    w = 4
    if k == 5 then w = 3 end
    if k == 6 then w = 2 end
    for i = -w, w, 1 do
      mx, my = get_map_pos_rel(k*dx+i*lx, k*dy+i*ly-0.5)
      t = get_map_type(mx, my)
      if can_dig(t) then
        remove_map_pixel(mx, my)
      end
      if terrain.is_strong(t) and k > 2 then return end
    end
  end

end
