required_objects = { "blade" }

max_energy = 2.5
req_energy = 2.5

function launch()
  play_sound("blade")
  px, py = get_platform_pos()
  id = create_object("blade", get_platform_dir(), get_platform_id())
  set_wait_object(id)
end
