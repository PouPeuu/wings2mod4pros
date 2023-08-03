image = "wheel"
bounding_circle_radius = 2
hit_damage = 0
hit_impulse = 0
mass = 100
volume = 0.03
air_resistance = 1.0
ground_kills = false
indestructible = true

function init(attach_id, offsetX, offsetY, owner_id)
	set_owner(owner_id)
	attach_to(attach_id)

	ox, oy = get_object_pos(attach_id)

	dirX = ox+offsetX-ox
	dirY = oy+offsetY-oy

	--set_attach_pos(, offsetY)
end