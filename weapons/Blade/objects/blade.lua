animation = "blade"

mirror_animation = true
lifetime = 0.3
has_dir = true

bounding_circle_radius = 3.2

hit_damage = 0
hit_impulse = 0
touch_damage = 0


function init(dir, owner_id)
  attach_to(owner_id)

  if get_object_type(owner_id) == "glider" then
    if dir >= 0 and dir <= 180 then
      set_attach_pos(110, 5, 1, true)
    else
      set_attach_pos(-110, 5, -1, true)
    end
  else
    if dir >= 0 and dir <= 180 then
      set_attach_pos(60, 6, 1, true)
    else
      set_attach_pos(-60, 6, -1, true)
    end
  end

  set_owner(owner_id)
  this.hit = 0
end

function on_hit_object(id)
  if get_age() > 0.18 and id ~= get_owner() and this.hit == 0 then
    cause_damage(id, 30)
    this.hit = 1
  end
end

function write_data()
  write_int8(this.hit)
end

function read_data()
  this.hit = read_int8()
end
