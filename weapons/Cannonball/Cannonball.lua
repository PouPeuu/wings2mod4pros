required_objects = { "cannonball" }

max_energy = 55
req_energy = 55
recoil = 17000


function launch()
  dx, dy = get_dir_vector(get_platform_dir())
  id = create_object("cannonball", dx*8, dy*8, dx*280, dy*280, get_platform_id())
  play_sound("cb_shoot")
end
