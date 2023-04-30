required_objects = { "cannonball2" }

max_energy = 140
req_energy = 140
recoil = 18000


function launch()
  play_sound("cb_shoot")
  dir = get_platform_dir()
  dx, dy = get_dir_vector(dir)
  id1 = 0
  shot_id = math.random(1, 10000)

  dir = get_platform_dir()
  dir_right = dir + 90
  sx, sy = get_dir_vector(dir_right)

  for i = 1, 5 do
    rd = math.random(360)
    rx, ry = get_dir_vector(rd)
    rs = 40 * math.random()
    fs = 40 * (0.5 - math.random())
    side_speed = 120 * (0.25 * (3.0 - i))
    id2 = create_object("cannonball2", dx*8, dy*8, side_speed*sx+rs*rx+dx*220+dx*fs, side_speed*sy+rs*ry+dy*220+dy*fs, shot_id, get_platform_id())
    if id1 ~= 0 then
      create_object("rope", 4, 30, id1, id2)
    end
    id1 = id2
  end
end

