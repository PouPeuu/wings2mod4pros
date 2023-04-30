lifetime = 5
send_reliably = true
remote_callbacks = true


function init(owner_id)
  set_owner(owner_id)
  attach_to(owner_id)
end


function run_simulation()
  if not is_alive(get_owner()) then 
    kill() 
    return
  end
  x, y = get_pos()
  fg_activate(x, y, 10)
end
