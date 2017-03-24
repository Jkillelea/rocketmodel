function [maxrange, water_vol] = test_water()
  addpath(genpath('../'));

  cfg        = get_cfg;
  coords0    = cfg.coords0;
  vel0       = cfg.vel0;
  vol_bottle = cfg.vol_bottle;
  m_empty    = cfg.m_empty;
  rho_w      = cfg.rho_w;
  P0         = cfg.P0;
  T0         = cfg.T0;
  R          = cfg.R;
  tmax       = cfg.tmax;

  water_vol_range = linspace(0.0005, 0.002, 100); % [m^3]
  maxrange  = [];
  water_vol = [];

  for w_vol = water_vol_range
    Vol_water_0 = w_vol;                       % [m^3]
    vol_air0    = vol_bottle - Vol_water_0;    % [m^3]
    m0          = m_empty + Vol_water_0*rho_w; % empty mass plus mass of water
    m_air0      = vol_air0*P0/(R*T0);          % volume of air times density of air V*(P/RT)

    [~, res] = ode45('rocket', [0, tmax], [coords0, vel0, m0, vol_air0, m_air0]);

    x = res(:, 1);
    maxrange(end+1)  = max(x);
    water_vol(end+1) = w_vol;
  end
end
