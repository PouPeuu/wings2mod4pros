required_objects = { "thruster_particle" }

visible_name = "Thrusters"
max_energy = 450
req_energy = 40
continuous_mode = true

speed = 140

function init()
  this.timer = 0
end


function launch()
  dir = get_platform_dir()
  
  dir = dir + (7.0 * (math.random() - 0.5))
  dx, dy = get_dir_vector(dir)
  power = 110000
  add_object_force(get_platform_id(), power*dx, power*dy)

  this.timer = this.timer + get_dt()
  if this.timer > 0.04 then
    create_object("thruster_particle", -dx*10, -dy*10, -speed*dx, -speed*dy, get_platform_id())
    this.timer = this.timer - 0.04
  end
  
end

