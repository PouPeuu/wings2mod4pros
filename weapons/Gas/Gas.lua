-- Drops a gas bomb
-- Created 2005-04-12 by Miika

required_objects = { "gas_bomb", "gas_burst", "gas" }

max_energy = 270
req_energy = 270

function launch()
  play_sound("fall")
  dir = get_platform_dir()
  dx, dy = get_dir_vector(dir)
  vx, vy = get_platform_vel()
  create_object("gas_bomb", 0, 2, -vx/4, -vy/4+80, get_platform_id())
end
