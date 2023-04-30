-- Particles rotating around the ship and destroying ground.
-- Created 2004-03-06 by Sami
-- Modified 2005-04-17: Now possible to drop

required_objects = { "digger" }

max_energy = 120
req_energy = 120
phases = 2

function init()
  this.digger = 0
end

function run()
  if get_phase() == 2 then
    if not is_alive(this.digger) then
      reset_phase()
    end
  end
end

function launch()
  if get_phase() == 1 then
    px, py = get_platform_pos()
    id = create_object("digger", px, py, get_platform_id())
    this.digger = id
    set_wait_object(id)
  end

  if get_phase() == 2 then
    if is_alive(this.digger) then
      call_object(this.digger)
    else
      px, py = get_platform_pos()
      id = create_object("digger", px, py, get_platform_id())
      this.digger = id
      set_wait_object(id)
    end
  end
end
