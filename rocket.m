% NOTES:
% Need to account for relative wind in 3D sense
% rocket heading is always into relative wind - pass in velocity as 3d vec,
% then subtract wind velocity, then use that to determine ground speed?
function deltas = rocket(~, state)
  % x       = state(1);
  % y       = state(2);
  z       = state(3);
  vx      = state(4); % groundspeed
  vy      = state(5);
  vz      = state(6);
  m       = state(7);
  pitch   = state(8); % degrees above horizontal
  vol_air = state(9);
  m_air   = state(10);

  % IMPORTS
  cfg        = get_cfg(); % import config
  c_disch    = cfg.c_disch;
  A_t        = cfg.A_t;
  rho_w      = cfg.rho_w;
  P_amb      = cfg.P_amb;
  R          = cfg.R;
  vol_bottle = cfg.vol_bottle;
  m_air0     = cfg.m_air0;
  g          = cfg.g;
  wind       = cfg.wind;


  if z < 0 % if rocket has hit the ground nothing changes
    deltas = zeros(1, length(state));
    return
  end

  dir_vec      = [vx vy vz]./norm([vx vy vz]); % unit vector in direction of velocity
  relative_vel = [vx vy vz] - wind; % velocity in 3D
  v            = norm(relative_vel);

  % calculate drag
  drag = drag_calc(v);

  % Pressure during water phase depends on volume of air (isentropic expansion)
  P0            = cfg.P0;
  vol_air0      = cfg.vol_air0;
  P_water_phase = P0*(vol_air0/vol_air)^1.4;

  % State when we run out of water
  P_end   = P0*(vol_air0/vol_bottle)^1.4;
  % T_end   = T0*(vol_air0/vol_bottle)^(1.4-1);
  P_air   = P_end*(m_air/m_air0)^1.4; % pressure during the air phase depends on the mass of air
  rho_air = m_air/vol_bottle;
  T       = P_air/(rho_air*R);
  P_crit  = P_air*(2/2.4)^(1.4/0.4);

  % water thrust
  if vol_air < cfg.vol_bottle
    dm_air   = 0;
    dm       = -c_disch*A_t*sqrt( 2*rho_w*(P_water_phase-P_amb) );
    thrust   = 2*c_disch*(P_water_phase - P_amb)*A_t;             % force of water exiting bottle
    dvol_air = c_disch*A_t*sqrt( (2/rho_w)*(P_water_phase-P_amb) );

  % air thrust
  elseif P_air > P_amb

    % choked flow
    if P_crit > P_amb
      P_e   = P_crit;          % pressure at the exit is the critical pressure
      T_e   = 2/(2.4)*T;       % temperature
      V_e   = sqrt(1.4*R*T_e); % velocity is mach 1 (temperature at exit derived from temp in bottle)
      rho_e = P_e/(R * T_e);   % density from ideal gas equation

    % unchoked
    else
      P_e   = P_amb;                                 % pressure at the exit is ambient pressure
      M_e   = sqrt( (2/0.4)*( ((P_air/P_amb)^(0.4/1.4)) - 1)); % calculate mach number from pressure ratio
      T_e   = T * (1 + (0.4/2)*(M_e^2));             % calc temperature at exit from mach number, isentropic relations
      V_e   = M_e * sqrt(1.4*R*T_e);                 % calculate velocity from mach number
      rho_e = P_amb/(R * T_e);                       % density from ideal gas equation

    end
    dm       = 0;
    dm_air   = -c_disch*rho_e*A_t*V_e;
    thrust   = -dm_air*V_e+(P_e-P_amb)*A_t;
    dvol_air = 0;

  % no thrust
  else
    thrust   = 0;
    dvol_air = 0;
    dm       = 0;
    dm_air   = 0;
  end

  dpitch = -g*cos(pitch)/v;
  if v <= 1 % if the rocket isn't going fast enough, assume it's still on the rails
    dpitch = 0;
  end

  dx = vx;
  dy = vy;
  dz = vz;
  dv = (thrust - drag -m*g*sin(pitch))/m; % a = sum(forces)/mass
  dvx = dv*dir_vec(1);
  dvy = dv*dir_vec(2);
  dvz = dv*dir_vec(3);

  % FIXME this is borken
  deltas = [dx, dy, dz, dm, dvx, dvy, dvz, dpitch, dvol_air, dm_air]'; % return a vector of the changes that occured

end
