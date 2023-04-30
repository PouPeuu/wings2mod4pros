animation = "emp_hit"
loop_animation = true

function init(owner_id)
  set_owner(owner_id)
  attach_to(owner_id)
  set_timer(0.2)
end

function on_timer()
  if not is_alive(get_owner()) then
    kill()
  end
  set_timer(0.2)
end

function on_call()
  kill()
end
