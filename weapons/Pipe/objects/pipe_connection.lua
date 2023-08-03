
ground_kills = false
static = true


function init(obj1, obj2)
	set_timer(0.1)
	this.obj1 = obj1
	this.obj2 = obj2
	this.attach1 = 0
	this.attach2 = 0
	send_game_message("at lst it exist")
end

function on_timer()

	if(not is_alive(this.obj1) or not is_alive(this.obj2)) then
		kill_object(this.obj1)
		kill_object(this.obj2)
		kill()
	end
	call_object(this.obj1,get_id())
	call_object(this.obj2,get_id())
	if this.attach1 ~= 0 and this.attach2 ~= 0 then
		send_game_message("lölli")
		call_object(this.attach1,get_id(),this.attach2)
		kill_object(this.obj1)
		kill_object(this.obj2)
		kill()
	end
	set_timer(0.5)
end

function on_call(id,attachid)
	send_game_message("exists")
	if(id==this.obj1) then
		this.attach1 = attachid
		send_game_message("1 attached")
	end
	if(id==this.obj2) then
		this.attach2 = attachid
		send_game_message("2 attached")
	end

end