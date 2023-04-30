image = "EMP_generator"
condition = 9.0
bounding_circle_radius = 3
hit_damage = 0
hit_impulse = 0
touch_damage = 0
mass = 20.0
volume = 0.2
air_resistance = 50.0
ground_kills = false
send_reliably = true
network_updates = true
poison_effect = 0.5


function init(x_pos, y_pos, x_vel, y_vel, owner_id)
  px, py = get_object_pos(owner_id)
  vx, vy = get_object_vel(owner_id)
  px, py = find_last_clear_point(px, py, px+x_pos, py+y_pos)
  set_pos(px, py)
  set_vel(vx+x_vel, vy+y_vel)
  set_owner(owner_id)
  this.pulses = 0
  this.activated = false
  set_timer(0.25)
end

function network_init()
  this.pulses = 0
  this.activated = false
  set_timer(0.25)
end


function on_call()
  this.activated = true
  set_timer(0.1)
end


function on_timer()
  if not this.activated then
    set_timer(0.25)
    network_update(1)
    return
  end
  
  create_object("EMP_object", 0, 0, 0, 0, get_id())
  play_sound("EMP")
  this.pulses = this.pulses + 1
  set_timer(2.8)
  network_update(1)
  if this.pulses >= 5 then
    kill()
  end
end

