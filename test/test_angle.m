function [maxrange, angles] = test_angle()
  addpath(genpath('../'));

  global cfg;

  % test from 1 to 89 degrees
  angle_range = 1:89;
  maxrange = [];
  angles   = [];

  for launch_angle = angle_range
    cfg = get_cfg_w_launch_angle(launch_angle);
    [~, res] = ode45('rocket', [0, cfg.tmax], [cfg.coords0, cfg.vel0,     ...
                                               cfg.m0,      cfg.vol_air0, ...
                                               cfg.m_air0]);

    x = res(:, 1);
    maxrange(end+1)  = max(x);
    angles(end+1) = launch_angle;
  end

end
