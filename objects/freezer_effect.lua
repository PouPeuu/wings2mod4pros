image = "icecube"

function init(owner_id)
  set_owner(owner_id)
  attach_to(owner_id)
  set_timer(0.2)
end

function on_timer()
  if not is_alive(get_owner()) then
    ice_break()
  end
  set_timer(0.2)
end

function on_call()
  ice_break()
end

function ice_break()
  power = 1
  n = 30 + math.random(10)
  n = n * power
  for i = 0, n do
    c = math.random(7)
    if c < 3 then 
      r = 195 
      g = 235 
      b = 235 
    elseif c < 5 then 
      r = 167
      g = 211
      b = 223 
    else 
      r = 215
      g = 247
      b = 255 
    end
    
    local lifetime = 1.0 + math.random();
    speed = power * (20 + math.random(64));
    dx, dy = random_vector()
    create_local_object("particle", 0, 0, speed*dx, speed*dy, r, g, b, 10, true, lifetime, 0.03)
  end
  
  kill()
end