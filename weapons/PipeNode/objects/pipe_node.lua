image = "pipe_node"
condition = 50
bounding_circle_radius = 15
static = true

function init(x_pos, y_pos, owner_id)
  px, py = get_object_pos(owner_id)
  vx, vy = get_object_vel(owner_id)
  px, py = find_last_clear_point(px, py, px+x_pos, py+y_pos)
  set_pos(px, py)
  set_owner(owner_id)
  attach_to_ground(true)
end
 
function on_call(id, attachid)
  send_game_message(get_id().." "..attachid.." "..get_object_type(attachid))
  kill_object(attachid)
  kill()

end
