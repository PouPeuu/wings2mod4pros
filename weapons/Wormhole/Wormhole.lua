required_objects = { "wormhole_start", "wormhole_end" }

max_energy = 280
req_energy = 280
phases = 2

function init()
  this.endpoint = 0
end

function run()
  if get_phase() == 2 then
    if not is_alive(this.endpoint) then
      reset_phase()
    end
  end
end


function launch()
  if get_phase() == 1 then
    id = create_object("wormhole_end", 0, get_platform_id())
    this.endpoint = id
  end

  if get_phase() == 2 then
    id = create_object("wormhole_start", this.endpoint, get_platform_id())
    call_object(this.endpoint, id)
  end
end
