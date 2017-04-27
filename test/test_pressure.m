function [maxrange, pressure] = test_pressure()
  addpath(genpath('../'));

  num_iterations  = 20;
  pressure_range  = linspace(10, 50, num_iterations); % psi
  maxrange        = zeros(1, num_iterations);
  pressure        = zeros(1, num_iterations);

  counter = 1;
  for pres = pressure_range
    cfg = get_cfg;
    cfg.P0 = toPa(pres) + cfg.P_amb;
    cfg.m_air0  = cfg.vol_air0*cfg.P0/(cfg.R*cfg.T0);

    initial_conds = [cfg.coords0, cfg.vel0, cfg.m0, cfg.vol_air0, cfg.m_air0];
    [~, res] = ode45( @(t, y) rocket(t, y, cfg), [0, cfg.tmax], initial_conds);

    x = res(:, 1);
    maxrange(counter) = max(x);
    pressure(counter) = pres;

    counter = counter + 1;
    fprintf('.');
  end
end
