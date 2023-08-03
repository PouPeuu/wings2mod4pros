
required_objects = {}

max_energy = 1
req_energy = 1
req_energy_level = 1
delay = 0
recoil = 0
speed = 100
spread = 5

math.randomseed(os.time())

function piss(dx,dy)
  create_object("particle", 0, 0, dx*speed+math.random(-spread,spread), dy*speed+math.random(-spread,spread), 232, 217, 0, 2, false, 5, 0.5)
end

function launch()
  dir = get_platform_dir()
  dx, dy = get_dir_vector(dir)
  x, y = get_platform_pos()

  piss(dx,dy)
  piss(dx,dy)
  piss(dx,dy)
end
