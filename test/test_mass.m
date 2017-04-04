function [maxrange, mass] = test_mass()
  addpath(genpath('../'));

  cfg         = get_cfg;
  vel0        = cfg.vel0;
  rho_w       = cfg.rho_w;
  Vol_water_0 = cfg.Vol_water_0;
  vol_air0    = cfg.vol_air0;
  m_air0      = cfg.m_air0;
  tmax        = cfg.tmax;
  coords0     = cfg.coords0;

  num_iterations = 100;
  m_empty_range  = linspace(0.04, 0.5, num_iterations); % [m^3]
  maxrange  = [];
  mass      = [];

  for m_empty = m_empty_range
    m0 = m_empty + Vol_water_0*rho_w; % empty mass plus mass of water
    cfg.m_empty = m_empty;

    [~, res] = ode45('rocket', [0, tmax], [coords0, vel0, m0, vol_air0, m_air0]);

    x = res(:, 1);
    maxrange(end+1) = max(x);
    mass(end+1)     = m_empty;
  end
end
