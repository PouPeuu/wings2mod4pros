-- Version 0.2
-- Created 2006-03-04 by Jarkko Iso-Heiko (JTS)

required_objects = { "gravity_obj" }

max_energy = 90
req_energy = 90
trigger_mode = 3
max_power_time = 2
phases = 2
    
function launch(power)
  dx, dy = get_platform_pos()
  platform = get_platform_id()
  if get_phase() == 1 then
    this.blackhole = create_object("gravity_obj", dx, dy, platform)
  end
  
  if get_phase() == 2 then    
    if is_alive(this.blackhole) then
      if is_server() then
        call_object(this.blackhole)
      else
        remote_call_object(this.blackhole)
      end
    else
      set_phase(1)
      dx, dy = get_platform_pos()
      this.blackhole = create_object("gravity_obj", dx, dy, platform)
    end
  end
end

function run()
  if get_phase() == 2 then
    if is_alive(this.blackhole) == false then
      reset_phase()
    end
  end
end
