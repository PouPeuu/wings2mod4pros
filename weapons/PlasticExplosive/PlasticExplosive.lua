required_objects = { "plastic_explosive" }

short_name = "PlasticExpl"
max_energy = 450
req_energy = 18
delay = 0.15


function init()
  this.base = 0
end

function launch()
  dir = get_platform_dir()
  dir = dir + (16 * (math.random() - 0.5))
  dx, dy = get_dir_vector(dir)

  id = create_object("plastic_explosive", dx*8, dy*8, dx*200, dy*200, get_platform_id())
  this.base = id
end
