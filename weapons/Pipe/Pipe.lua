required_objects = { "pipe" }

max_energy = 50
req_energy = 50
phases = 2


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
    id = create_object("pipe", 0, 0, 200*dx, 200*dy, get_platform_id())
    this.obj1 = id
  end

  if get_phase() == 2 then
    dx, dy = get_dir_vector(get_platform_dir())
    obj2 = create_object("pipe", 0, 0, 200*dx, 200*dy, get_platform_id())
    create_object("pipe_connection", this.obj1, obj2)
    this.obj1 = 0
  end
end