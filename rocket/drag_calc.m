function d = drag_calc(v, cfg)
  % debuglog('drag');
  rho         = cfg.rho_atmo;
  Cd          = cfg.Cd;
  bottle_area = cfg.bottle_area;
  d           = 0.5*rho*(v^2) * Cd * bottle_area;
  return
end
