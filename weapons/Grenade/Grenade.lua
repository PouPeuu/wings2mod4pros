max_energy = 20
req_energy = 20
recoil = 1000
trigger_mode = 3
max_power_time = 1


function launch(power)
  play_sound("grenade")
  dir = get_platform_dir()
  dx, dy = get_dir_vector(dir)
  create_object("grenade", dx*8, dy*8, power*190*dx, power*190*dy)
end

