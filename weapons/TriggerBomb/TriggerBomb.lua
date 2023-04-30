required_objects = { "triggerbomb" }

max_energy = 140
req_energy = 140
phases = 2
recoil = 4000

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
    dx, dy = get_dir_vector(get_platform_dir())
    id = create_object("triggerbomb", dx*8, dy*8, dx*100, dy*100, get_platform_id())
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
      dx, dy = get_dir_vector(get_platform_dir())
      id = create_object("triggerbomb", dx*8, dy*8, dx*100, dy*100, get_platform_id())
      this.explosive = id
    end
  end

end
