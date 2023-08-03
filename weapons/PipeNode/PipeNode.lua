required_objects = { "pipe_node" }

visible_name = "Pipe Node"
max_energy = 50
req_energy = 50

function launch()
  dir = get_platform_dir()
  dx, dy = get_dir_vector(dir)
  vx, vy = get_platform_vel()
  create_object("pipe_node",0,0,get_platform_id())
end
