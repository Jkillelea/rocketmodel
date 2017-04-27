function [maxrange, cd_vec] = test_cd()
  addpath(genpath('../'));

  num_iterations = 20;
  cd_range = linspace(0, 1, num_iterations); % [m^3]
  maxrange = zeros(1, num_iterations);
  cd_vec   = zeros(1, num_iterations);

  counter = 1;
  for cd_val = cd_range
    cfg    = get_cfg;
    cfg.Cd = cd_val;

    inital_conds = [cfg.coords0, cfg.vel0, cfg.m0, cfg.vol_air0, cfg.m_air0];
    [~, res] = ode45(@(t, y) rocket(t, y, cfg), [0, cfg.tmax], inital_conds);

    x = res(:, 1);
    maxrange(counter)  = max(x);
    cd_vec(counter)    = cd_val;

    counter = counter + 1;
    fprintf('.');
  end
end
