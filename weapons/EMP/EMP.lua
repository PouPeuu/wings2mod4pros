required_objects = { "EMP_generator", "EMP_object" }

max_energy = 300
req_energy = 300
phases = 2

function init()
  this.explosive = 0
end

function run()
  if get_phase() == 2 then
    if not is_alive(this.explosive) then
      reset_phase()
    end
  end
end

function launch()

  if get_phase() == 1 then
    vx, vy = get_platform_vel()
    id = create_object("EMP_generator", 0, 0, -vx/4, -vy/4+80, get_platform_id())
    set_wait_object(id)
    this.explosive = id
  end

  if get_phase() == 2 then
    if is_alive(this.explosive) then
      if is_server() then
        call_object(this.explosive)
      else
        remote_call_object(this.explosive)
      end
    else
      set_phase(1)
      vx, vy = get_platform_vel()
      id = create_object("EMP_generator", 0, 0, -vx/4, -vy/4+80, get_platform_id())
      this.explosive = id
    end
  end

end
