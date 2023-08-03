load_mode = 2
req_energy = 100
num_shots = 50
shot_energy = 1
spread = 100

function fardGas(dx,dy)
  fardspeed = 25
  fardoffset = 30
  create_object("gas",-dx*fardoffset,-dy*fardoffset,-dx*fardspeed+math.random(-spread,spread),-dy*fardspeed+math.random(-spread,spread),get_platform_id())
end

function launch()
  play_sound("fard1")
  dir = get_platform_dir()
  dx, dy = get_dir_vector(dir)

  fartpower = 150000
  add_object_force(get_platform_id(),dx*fartpower,dy*fartpower)

  for i=0,2 do
    fardGas(dx,dy)
  end
end
