load_mode = 2
req_energy = 80
num_shots = 12
shot_energy = 3
recoil = 1200

function init()
end

function launch()
  dx, dy = get_dir_vector(get_platform_dir())
  id = create_object("bullet", dx*8, dy*8, dx*220, dy*220)
  play_sound("gun")
end
