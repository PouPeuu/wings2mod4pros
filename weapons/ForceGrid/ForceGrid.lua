required_objects = { "fg_obj" }

max_energy = 250
req_energy = 250
phases = 2


function init()
  this.obj = 0
end


function run()
  if get_phase() == 2 then
    if not is_alive(this.obj) then
      reset_phase()
    end
  end
end


function launch()
  if get_phase() == 1 then
    obj = create_object("fg_obj", get_platform_id())
    this.obj = obj
    set_wait_object(obj)
  end
  if get_phase() == 2 then
    if is_alive(this.obj) then
      kill_object(this.obj)
    else
      obj = create_object("fg_obj", get_platform_id())
      set_wait_object(obj)
      this.obj = obj
      set_wait_object(obj)
    end
  end
end
