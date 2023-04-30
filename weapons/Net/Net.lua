required_objects = { "net_object" }

max_energy = 160
req_energy = 160

function launch()

  speed = 170

  net_id = math.random(1, 10000)

  dx, dy = get_dir_vector(get_platform_dir())
  rdx, rdy = get_dir_vector(get_platform_dir()+90)
  
  l = 2
  h = l*math.sin(60*0.017952)
  k = 5
  spread = 1.5

  id = {}
  n = 0
  y = 0
  for x = 1, 4 do
    ground = 2
    if x == 1 then 
      ground = 1 
    end
    h = 1.0 + 0.03*math.abs(x-2.5)
    id[n] = create_object("net_object", rdx*(x*l-2.5*l) + dx*y, rdy*(x*l-2.5*l) + dy*y, 
      spread*k*(rdx*(x*l-2.5*l) + dx*y) + h*speed*dx, spread*k*(rdy*(x*l-2.5*l) + dy*y) + h*speed*dy, ground, net_id, get_platform_id())
    n = n+1
  end
  for x = 1, 3 do
    create_object("rope", 3, 30, id[x-1], id[x])
  end
    create_object("rope", 3, 30, id[0], id[2])
    create_object("rope", 3, 30, id[1], id[3])


end
