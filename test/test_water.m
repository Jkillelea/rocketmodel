function [maxrange, water_vol] = test_water()
  addpath(genpath('../'));

  global cfg;

  num_iterations = 100;
  water_vol_range = linspace(0.00001, 0.001, num_iterations); % [m^3]
  maxrange  = [];
  water_vol = [];

  for w_vol = water_vol_range
    cfg = get_cfg_w_water_vol(w_vol);

    [~, res] = ode45('rocket', [0, cfg.tmax], [cfg.coords0, cfg.vel0, cfg.m0, cfg.vol_air0, cfg.m_air0]);

    x = res(:, 1);
    maxrange(end+1)  = max(x);
    water_vol(end+1) = w_vol;
    fprintf('.');
  end
end
