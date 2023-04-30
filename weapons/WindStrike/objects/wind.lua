has_dir = true
remote_callbacks = true


function init(owner_id)
  px, py = get_object_pos(owner_id)
  set_pos(px, py)
  vx, vy = get_object_vel(owner_id)
  set_vel(vx, vy)
  set_dir(get_object_dir(owner_id))
  set_owner(owner_id)
  set_timer(0)
end

function read_data()
  set_timer(0)
end
	
		
function on_timer()
  dir = get_dir()
  sdx, sdy = get_dir_vector(dir)
  for n = 1, 2 do
    speed = 270 + 60 * math.random()
    if math.random() < 0.5 then 
      dc = math.random(60)*math.sqrt(math.random())
    else
      dc = 360 - math.random(60)*math.sqrt(math.random())
    end
    dist = 3 + 10 * math.random()
    dx, dy = get_dir_vector(dir+dc)
    create_local_object("wave_particle_3", dx*dist, dy*dist, dx*speed, dy*speed, get_owner())
  end
  kill()
end
