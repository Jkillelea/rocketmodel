function cfg = get_cfg_w_water_vol(w_vol)
  % TAKES WATER VOL IN M^3
  % EDITING THIS FILE: Be sure to change the names everywhere
  % Values only have to be changed in one place.
  % This function returns a struct which contains all the fields seen below

  cfg = get_cfg;

  cfg.Vol_water_0 = w_vol;                                     % [m^3]
  cfg.vol_air0    = cfg.vol_bottle - cfg.Vol_water_0;          % [m^3]
  cfg.m0          = cfg.m_empty + cfg.Vol_water_0 * cfg.rho_w; % empty mass plus mass of water
  cfg.m_air0      = cfg.vol_air0 * cfg.P0 / (cfg.R * cfg.T0);  % volume of air times density of air V*(P/RT)

end
