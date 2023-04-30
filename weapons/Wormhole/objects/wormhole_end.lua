animation = "wormhole_end"
loop_animation = true
bounding_circle_radius = 16
lifetime = 300
static = true
remote_callbacks = true
send_reliably = true
network_updates = true


function init(endpoint_id, owner_id)
  px, py = get_object_pos(owner_id)
  set_pos(px, py)
  set_owner(owner_id)
  this.startpoint = 0
  set_timer(1)
end

function network_init()
  this.startpoint = 0
end

function write_data()
  write_int32(this.startpoint)
end

function read_data()
  this.startpoint = read_int32()
end


function on_timer()
  if this.startpoint == 0 and not is_alive(get_owner()) then
    kill()
  end
  set_timer(1)
end


function on_hit_object(id)
  if not is_server() then return end

  if get_object_type(id) == "laser" then kill() call_object(this.startpoint) return end
  if get_object_type(id) == "wormhole_start" then
    call_object(this.startpoint)
    kill()
  end
end

function on_call(caller_id)
  this.startpoint = caller_id
  network_update(2)
  if caller_id == 0 then
    kill()
  end
end


