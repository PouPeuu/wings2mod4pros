required_objects = {}

max_energy = 1
req_energy = 1
req_energy_level = 1
delay = 0
recoil = 7500
speed = 200
knockback = 100

function launch()
  dir = get_platform_dir()
  dx, dy = get_dir_vector(dir)
  x, y = get_platform_pos()

  hitX, hitY = find_first_solid_point(x,y,x+dx*1000,y+dy*1000)
  objects = get_objects_from_line(x,y,hitX,hitY,5)
  for i,v in pairs(objects) do
    add_object_impulse(v,dx*knockback,dy*knockback)
  end
  --id = create_object("particle",hitX-x,hitY-y,0,0,255,255,255,5,true,0.1,0)
  id = create_object("small_explosion", hitX-x, hitY-y, 0, 0)
  create_object("small_explosion", hitX-x, hitY-y, 0, 0)
  create_object("small_explosion", hitX-x, hitY-y, 0, 0)
  create_object("rope",1,0.1,get_platform_id(),id)
end