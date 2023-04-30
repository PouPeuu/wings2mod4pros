-- Machinegun, v4.1
-- Created 2004-01-24 by Sami

load_mode = 2
req_energy = 180
num_shots = 50
shot_energy = 1
recoil = 1500

function init()
  this.rdir = 0
  this.heat = 0
end

function run()
  if this.heat > 50 then
    dx, dy = get_dir_vector(dir)
    col = 120 + 40 * math.random();
    create_object("smoke", 8*dx, 8*dy, 20*dx, 20*dy, col, col, col, 1)
  end
  this.heat = this.heat * 0.8
end

function launch()

  idx = get_platform_id()
  dir = get_platform_dir()
  dx, dy = get_dir_vector(dir)
  dir_left = dir - 90
  dir_right = dir + 90
  lx, ly = get_dir_vector(dir_left)
  rx, ry = get_dir_vector(dir_right)

  if is_first_shot() then
    play_sound("ship_hit", 100)
    this.heat = this.heat + 4
    this.rdir = 0
    s1x = dx
    s1y = dy
    s2x = dx
    s2y = dy
  else
    this.heat = 1.25 * this.heat
    this.heat = this.heat + 4

    if this.heat > 60 then
      play_sound("ship_wallhit", 128, 1)
	  set_fire_delay(3)
      this.heat = 0
    elseif this.heat > 20 then
      chdir = 0.25 * this.heat * (math.random() + math.random() - 1)
      set_platform_dir(dir + chdir)
      if chdir > 4 then play_sound("ship_wallhit", 64, 2)
      else play_sound("ship_hit", 100) end
    else
      play_sound("ship_hit", 100)
    end

    if math.abs(this.rdir) >= 30 then c = 0
    else c = 1 - this.rdir^2 / 900 end
    this.rdir = this.rdir + c * 2 * (math.random() + math.random() - 1) - (1 - c) * 0.5 * this.rdir
    s1x, s1y = get_dir_vector(dir + this.rdir)
    this.rdir = this.rdir + c * 2 * (math.random() + math.random() - 1) - (1 - c) * 0.5 * this.rdir
    s2x, s2y = get_dir_vector(dir + this.rdir)
  end
  
  create_object("shot", s1x*7, s1y*7, 300*s1x, 300*s1y)
  create_object("shot", s2x*17, s2y*17, 300*s2x, 300*s2y)

  red = 140
  green = 130
  blue = 120
  nspeed = 150
  if this.heat > 25 then
    red = math.min(255, red + 4 * (this.heat - 25))
    green = math.max(0, green - 0.5 * (this.heat - 25))
    blue = math.max(0, blue - 1.5 * (this.heat - 25))
    nspeep = nspeed + 10 * (this.heat - 25)
  end
  create_object("particle", rx*5+5*dx, ry*5+5*dy, (rx-0.5*dx)*nspeed*(0.2+math.random()), (ry-0.5*dy)*nspeed*(0.2+math.random()), red, green, blue, 12, true, 60, 0.1)

end
