image = "neutral_flag"
mass = 120.0
volume = 1
air_resistance = 2000.0
-- bounding_circle_radius = 10
collision_point_y = 14
ground_kills = false
-- indestructible = true
network_updates = true
static = true


function init(x_pos, y_pos, x_vel, y_vel, owner_id)
  if owner_id ~= 0 then
    px, py = get_object_pos(owner_id)
    vx, vy = get_object_vel(owner_id)
    px, py = find_last_clear_point(px, py, px+x_pos, py+y_pos)
    set_animation("flag")
  else
    px = x_pos
    py = y_pos
    vx = 0
    vy = 0
  end
  
  set_pos(px, py)
  set_vel(vx+x_vel, vy+y_vel)
  if owner_id ~= 0 then set_owner(owner_id) end
  this.score_time = 0
  this.capture_time = 0
  this.capture_team = 0
  set_timer(0.5)
end

function network_init()
  this.score_time = 0
  this.neutral = true
  this.capture_time = 0
  this.capture_team = 0
end


function on_timer()
  x, y = get_pos()
  objs = get_objects_from(x, y, 75)
 
  teams = {}
  num_teams = 0

  for index, obj in pairs(objs) do
    t = get_object_type(obj)
    if t == "ship" or t == "pilot" or t == "glider" then
      if get_object_player(obj) ~= 0 then
        team = get_object_team(obj)
        if teams[team] == nil then
          teams[team] = 2
          num_teams = num_teams + 1
        else
          teams[team] = teams[team] + 2
        end
      end
    elseif t == "trooper" or t == "cannon" or t == "turret" or t == "walker" then
      team = get_object_team(obj)
      if teams[team] == nil then
        teams[team] = 1
        num_teams = num_teams + 1
      else
        teams[team] = teams[team] + 1
      end
    end
  end
  
  owner = get_object_team(get_id())
  
  if num_teams > 0 then
    max = 0
    max_team = 0
    current_size = 0
    for team, num in pairs(teams) do
      if team == owner then 
        current_size = num 
      end
      if num > max or (num == max and team ~= owner) then
        max = num 
        max_team = team
      end
    end
    
    neutral = false
    if owner == 0 then
      for team, num in pairs(teams) do
        if team ~= max_team and num == max then
          neutral = true
          this.capture_time = 0
          this.capture_team = 0
          set_text("")
          break
        end
      end
    end
    
    if not neutral then
      if max_team ~= owner then
        if max == current_size then
          winner = 0
        elseif max > current_size then
          winner = max_team
        end
        
        if winner ~= this.capture_team then
          if winner ~= 0 and this.capture_team ~= 0 then
            this.capture_time = 0
            set_text("")
          end
          this.capture_team = winner
        else
          this.capture_time = this.capture_time + 0.5
          time_left = 10 - math.floor(this.capture_time)
          if time_left ~= 0 then
            set_text(time_left) 
          else
            set_text("")
          end
          if this.capture_time >= 10 then
            send_game_message("FC: " .. get_object_team(get_id()) .. " " .. winner)
            set_object_team(get_id(), winner)
            if winner ~= 0 then set_animation("flag")
            else set_image("neutral_flag") end
            network_update(2)
          end
        end
      else
        this.capture_time = 0
        this.capture_team = 0
        set_text("")
      end
      
    end
  else
    this.capture_time = 0
    this.capture_team = 0
    set_text("")
  end  

  network_update(1)
  
  if owner ~= 0 then
    if get_time() > this.score_time + 5 then
      add_team_points(owner, 1)
      this.score_time = get_time()
    end
  end
    
  set_timer(0.5)
end


function write_data()
  write_int32(2*this.capture_time)
end

function read_data()
  this.capture_time = read_int32() / 2
  time_left = 10 - math.floor(this.capture_time)
  if this.capture_time ~= 0 and time_left ~= 0 then set_text(time_left)
  else set_text("") end

  if get_team() ~= 0 then
    set_animation("flag")
  else
    set_image("neutral_flag")
  end
end

