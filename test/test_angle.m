function [maxrange, angles] = test_angle()
  addpath(genpath('../'));

  % test from 1 to 89 degrees
  angle_range = 1:89;
  maxrange    = zeros(1, length(angle_range));
  angles      = zeros(1, length(angle_range));

  counter = 1;
  for launch_angle = angle_range
    cfg = get_cfg_w_launch_angle(launch_angle);

    inital_conds = [cfg.coords0, cfg.vel0, cfg.m0, cfg.vol_air0, cfg.m_air0];

    [~, res] = ode45(@(t, y) rocket(t, y, cfg), [0, cfg.tmax], inital_conds);

    x = res(:, 1);
    maxrange(counter) = max(x);
    angles(counter)   = launch_angle;
    
    counter = counter + 1;
    fprintf('.');
  end

end
