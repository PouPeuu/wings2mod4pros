load_mode = 2
req_energy = 190
num_shots = 6
shot_energy = 6
recoil = 5000



function init()
end


function launch()
  play_sound("shoot_gl")
  dx, dy = get_dir_vector(get_platform_dir())
  create_object("grenade2", dx*8, dy*8, dx*250, dy*250, get_platform_id())
end

