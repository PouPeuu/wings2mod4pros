network_updates = true

function init(x, y, owner_id)
	set_owner(owner_id)
	set_pos(x, y)
	id = create_object("walker", 0, 0, 0, 0)
	cause_damage(id, 120)
	set_object_pos(id, 0, 0)
	kill_object(id)
	network_update(2)
end