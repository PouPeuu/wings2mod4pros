required_objects = { "firebomb", "wildfire", "smallflame", "wf_flame" }

max_energy = 85
req_energy = 85
recoil = 4000


function launch()
  dx, dy = get_dir_vector(get_platform_dir())
  id = create_object("firebomb", dx*8, dy*8, dx*120, dy*120, get_platform_id())
  play_sound("wildfire")
end
