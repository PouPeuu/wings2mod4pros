required_objects = { "rooper" }

max_energy = 45*5--*2
req_energy = 45--*2
delay = 0.35

function launch()
  px, py = get_platform_pos()
  create_object("rooper", px, py, get_platform_id())
end

