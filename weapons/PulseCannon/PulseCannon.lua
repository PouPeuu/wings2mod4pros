required_objects = { "pulse" }

max_energy = 120
req_energy = 10
req_energy_level = 40
recoil = 800

delay = 0.08

function init()
  this.pos = 0
end


function launch()
  dx, dy = get_dir_vector(get_platform_dir())
  this.pos = math.fmod(this.pos + 1, 2)
  rx, ry = get_dir_vector(get_platform_dir()+90)
  p = -6
  if this.pos == 0 then p = 6 end
  
  id = create_object("pulse", dx*8+rx*p, dy*8+ry*p, dx*250, dy*250, get_platform_dir(), get_platform_id())
  play_sound("pulse_shoot")
end
