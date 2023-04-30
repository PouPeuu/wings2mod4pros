visible_name="Shotgun"
load_mode = 2
req_energy = 80
num_shots = 4
shot_energy = 10
recoil = 2500



function launch()
  play_sound("shotgun")
  dir = get_platform_dir()
  dx, dy = get_dir_vector(dir)
  for I = 1, 10 do
    rd = math.random(360)
    rx, ry = get_dir_vector(rd)
    rs = math.random()
    create_object("shot", dx*10, dy*10, 22*rs*rx+dx*220, 22*rs*ry+dy*220)
  end
end

