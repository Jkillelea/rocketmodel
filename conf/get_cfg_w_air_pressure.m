function cfg = get_cfg_w_air_pressure(air_pres)
  % TAKES PRESSURE IN PSI
  % EDITING THIS FILE: Be sure to change the names everywhere
  % Values only have to be changed in one place.
  % This function returns a struct which contains all the fields seen below

  cfg = get_cfg;

  cfg.P0 = toPa(air_pres) + cfg.P_amb;
  cfg.m_air0 = cfg.vol_air0 * cfg.P0 / (cfg.R * cfg.T0);
  
end
