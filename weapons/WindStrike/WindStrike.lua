required_objects = { "wind", "wave_particle_3" }

max_energy = 300
req_energy = 9
req_energy_level = 60
delay = 0.1

recoil = 1000

function launch()
  create_object("wind", get_platform_id())
end
