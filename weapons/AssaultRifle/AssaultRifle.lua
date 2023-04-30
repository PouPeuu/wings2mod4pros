-- Assault rifle for pilot, v2.0
-- Created 2004-01-06 by Sami

load_mode = 2
req_energy = 20
num_shots = 12
shot_energy = 0.5
recoil = 400

function init()
  this.rdir = 0
end

function launch()
  play_sound("gun", 100)

  idx = get_platform_id()
  dir = get_platform_dir()
  dx, dy = get_dir_vector(dir)
  if dx > 0 then dv = -1 else dv = 1 end

  dir_left = dir - 90
  dir_right = dir + 90
  lx, ly = get_dir_vector(dir_left)
  rx, ry = get_dir_vector(dir_right)
  
  if is_first_shot() then
    this.rdir = 0
    create_object("shot", dx*3, dy*3, dx*220, dy*220)
    create_object("particle", 0, -2, dv*20*(0.8+math.random()), -5*(0.8+math.random()), 130, 120, 80, 1, true, 60, 0.05)

  else
    c = (math.fmod(dir, 180) - 90)^2 / 8100
    this.rdir = this.rdir + 0.7 * (1.5 * (1 - c) * (math.random() + math.random() - 0.5) + (0.5 + c) * (2*math.random() - 1))
    d1x, d1y = get_dir_vector(dir+dv*this.rdir)
    this.rdir = this.rdir + 0.7*(1.5 * (1 - c) * (math.random() + math.random() - 0.5) + (0.5 + c) * (2*math.random() - 1))
    d2x, d2y = get_dir_vector(dir+dv*this.rdir)

    create_object("shot", d1x*10, d1y*10, 240*d1x, 240*d1y)
    create_object("shot", d2x*3, d2y*3, 240*d2x, 240*d2y)
    create_object("particle", 0, -2, dv*20*(0.8+math.random()), -5*(0.8+math.random()), 130, 120, 80, 1, true, 60, 0.05)

    if this.rdir > 1 then
      set_platform_dir(dir + dv * math.floor(this.rdir))
      this.rdir = this.rdir - math.floor(this.rdir)
    end

  end

end
