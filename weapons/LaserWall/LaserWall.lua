required_objects = { "laser_wall_object", "emp_effect" }

max_energy = 220
req_energy = 220
phases = 2
limited_object = "laser_wall_object"
limit = 16

function init()
  this.obj1 = 0
end

function run()
  if get_phase() == 2 then
    if not is_alive(this.obj1) then
      reset_phase()
    end
  end
end

function launch()

  if get_phase() == 1 then
    dx, dy = get_dir_vector(get_platform_dir())
    id = create_object("laser_wall_object", 0, 0, 200*dx, 200*dy, get_platform_id())
    this.obj1 = id
  end

  if get_phase() == 2 then
    dx, dy = get_dir_vector(get_platform_dir())
    obj2 = create_object("laser_wall_object", 0, 0, 200*dx, 200*dy, get_platform_id())
    laser = create_object("laser", this.obj1, obj2, get_object_team(get_platform_id()))
    this.obj1 = 0
  end

end
