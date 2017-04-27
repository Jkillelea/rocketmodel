function [maxrange, water_vol] = test_water()
  addpath(genpath('../'));

  num_iterations = 25;
  water_vol_range = linspace(0.00001, 0.001, num_iterations); % [m^3]
  maxrange  = zeros(1, num_iterations);
  water_vol = zeros(1, num_iterations);

  counter = 1;
  for w_vol = water_vol_range
    cfg = get_cfg_w_water_vol(w_vol);

    inital_conds = [cfg.coords0, cfg.vel0, cfg.m0, cfg.vol_air0, cfg.m_air0];
    [~, res] = ode45(@(t, y) rocket(t, y, cfg), [0, cfg.tmax], inital_conds);

    x = res(:, 1);
    maxrange(counter)  = max(x);
    water_vol(counter) = w_vol;
    
    counter = counter + 1;
    fprintf('.');
  end
end
