required_objects = { "explosive" }

max_energy = 160
req_energy = 160
max_power_time = 24
timer_start = 2
timer_end = 60
trigger_mode = 3


function launch(power)
  vx, vy = get_platform_vel()
  id = create_object("explosive", 0, 0, -vx/4, -vy/4+80, 2+58*power, get_platform_id())
end

