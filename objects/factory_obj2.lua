animation = "factory"
ground_kills = false
static = true
send_reliably = true


function init(x_pos, y_pos, team)
  set_pos(x_pos, y_pos)
  set_team(team)
  this.n = 0
  set_timer(0)
end

function network_init()
  this.n = 0
end


function on_timer()
  if this.n < 4 then
    create_object("explosion2", math.random(-8, 8), math.random(-8, 8), 0, 0)
    set_timer(0.15)
    this.n = this.n + 1
  else
    kill()
  end
end



