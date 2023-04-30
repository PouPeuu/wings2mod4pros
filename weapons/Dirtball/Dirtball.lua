-- Made by Zounas 2004-4-30

required_objects = { "dirtball" }

max_energy = 60
req_energy = 60

function init()
  this.base = 0
end

function launch()
  dir = get_platform_dir()
  dx, dy = get_dir_vector(dir)

  id = create_object("dirtball", dx*8, dy*8, dx*200, dy*200, get_platform_id())
  this.base = id
end
