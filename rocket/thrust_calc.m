function [f_thrust, dvol_air, dm, dm_air] = thrust_calc(vol_air, m_air)
  global cfg;
  c_disch    = cfg.c_disch;
  A_t        = cfg.A_t;
  rho_w      = cfg.rho_w;
  P_amb      = cfg.P_amb;
  R          = cfg.R;
  vol_bottle = cfg.vol_bottle;
  m_air0     = cfg.m_air0;
  P0         = cfg.P0;
  vol_air0   = cfg.vol_air0;

  % pressure (if we're in the water phase)
  P_water_phase = P0*(vol_air0/vol_air)^1.4;
  % State when we run out of water
  P_end   = P0*(vol_air0/vol_bottle)^1.4;
  P_air   = P_end*(m_air/m_air0)^1.4; % pressure during the air phase depends on the mass of air
  rho_air = m_air/vol_bottle;
  T       = P_air/(rho_air*R);
  P_crit  = P_air*(2/2.4)^(1.4/0.4);

  % water thrust
  if vol_air < cfg.vol_bottle
    dm_air   = 0;
    dm       = -c_disch*A_t*sqrt( 2*rho_w*(P_water_phase-P_amb) );
    f_thrust = 2*c_disch*(P_water_phase - P_amb)*A_t;             % force of water exiting bottle
    dvol_air = c_disch*A_t*sqrt( (2/rho_w)*(P_water_phase-P_amb) );
  % air thrust
  elseif P_air > P_amb
    if P_crit > P_amb % check for choked flow
      P_e   = P_crit;          % pressure at the exit is the critical pressure
      T_e   = 2/(2.4)*T;       % temperature
      V_e   = sqrt(1.4*R*T_e); % velocity is mach 1 (temperature at exit derived from temp in bottle)
      rho_e = P_e/(R*T_e);     % density from ideal gas equation

    else % unchoked
      P_e   = P_amb;                                 % pressure at the exit is ambient pressure
      M_e   = sqrt( (2/0.4)*( ((P_air/P_amb)^(0.4/1.4)) - 1)); % calculate mach number from pressure ratio
      T_e   = T * (1 + (0.4/2)*(M_e^2));             % calc temperature at exit from mach number, isentropic relations
      V_e   = M_e * sqrt(1.4*R*T_e);                 % calculate velocity from mach number
      rho_e = P_amb/(R * T_e);                       % density from ideal gas equation
    end

    dm       = 0;
    dm_air   = -c_disch*rho_e*A_t*V_e;
    f_thrust = -dm_air*V_e+(P_e-P_amb)*A_t;
    dvol_air = 0;

  % no thrust
  else
    f_thrust = 0;
    dvol_air = 0;
    dm       = 0;
    dm_air   = 0;
  end
end
