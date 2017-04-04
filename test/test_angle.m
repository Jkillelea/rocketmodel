function [maxrange, angles] = test_angle()
  addpath(genpath('../'));

  cfg        = get_cfg;
  coords0    = cfg.coords0;
  vol_air0   = cfg.vol_air0;
  m_air0     = cfg.m_air0;
  m0         = cfg.m0;
  tmax       = cfg.tmax;

  % test from 1 to 89 degrees
  angle_range = 1:89;
  maxrange = [];
  angles   = [];

  for launch_angle = angle_range
    vel0   = 0.3*[cosd(launch_angle) 0 sind(launch_angle)];% launch along x-y plane

    [~, res] = ode45('rocket', [0, tmax], [coords0, vel0, m0, vol_air0, m_air0]);

    x = res(:, 1);
    maxrange(end+1)  = max(x);
    angles(end+1) = launch_angle;
  end

end
