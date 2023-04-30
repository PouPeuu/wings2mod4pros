--Booby Trap, weapon for creating traps to the ground. Works great against troopers.
--Created by: Jarkko Iso-Heiko (JTS), wahit@mbnet.fi at 16th of July 2006

required_objects = { "infmineobj" }

max_energy = 120
req_energy = 120

function launch()
  vx, vy = get_platform_vel()
  dir1 = get_platform_dir()+3
  dir2 = get_platform_dir()-3
  a = 9*1.2*11
  for n=0,2 do
    dx1, dy1 = get_dir_vector(dir1)
    dx2, dy2 = get_dir_vector(dir2)
    create_object("infmineobj", dx1*9, dy1*9, dx1*a, dy1*a, get_platform_id())
    create_object("infmineobj", dx2*9, dy2*9, dx2*a, dy2*a, get_platform_id())
    dir1=dir1+7
    dir2=dir2-7
  end

end

