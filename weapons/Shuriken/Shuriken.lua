required_objects = { "shuriken" }

max_energy = 210
req_energy = 35
recoil = 3000

delay = 0.2

function init()
  this.pos = 0
end

function launch()
  dx, dy = get_dir_vector(get_platform_dir())
  
  rx, ry = get_dir_vector(get_platform_dir()+90)
  this.pos = math.fmod(this.pos + 1, 2)
  p = -6
  if this.pos == 0 then p = 6 end
  
  id = create_object("shuriken", dx*8+rx*p, dy*8+ry*p, dx*240, dy*240, get_platform_id())
  play_sound("shuriken_shoot")
end
