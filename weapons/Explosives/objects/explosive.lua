image = "explosive"
condition = 9.0
bounding_circle_radius = 3
hit_damage = 0
hit_impulse = 0
touch_damage = 0
mass = 20.0
volume = 0.2
air_resistance = 250.0
ground_kills = false
send_reliably = true
network_updates = true
remote_callbacks = true

color_r = 190
color_g = 190
color_b = 190
splint_speed = 180
min_time = 2


function init(x_pos, y_pos, x_vel, y_vel, time, owner_id)
  px, py = get_object_pos(owner_id)
  vx, vy = get_object_vel(owner_id)
  px, py = find_last_clear_point(px, py, px+x_pos, py+y_pos)
  set_pos(px, py)
  set_vel(vx+x_vel, vy+y_vel)
  set_owner(owner_id)
  this.time = time
  this.network_time = 0
  set_timer(0.05)
end

function network_init()
  this.time = 2
  this.network_time = 0
end

function write_data()
  write_int32(this.time)
end

function read_data()
  this.time = read_int32()
  set_timer(0.05)
end

function explode()
  create_object("big_explosion", 0, 0, 0, 0)
  kill()
end

function on_break()
  if is_server() then
    explode()
  end
end


function on_timer()
  show_timer(this.time - get_age())

  if is_server() then
    if get_age() > this.time then
      set_vel(0, 0)
      explode()
    else
      this.network_time = this.network_time + 1
      if this.network_time >= 2 then
        this.network_time = 0
        network_update(1)
      end
    end
  end
  
  set_timer(0.05)
end

