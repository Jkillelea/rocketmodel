function deltas = rocket(t, state)
  % UID 4e841e99f297
  % delta is column vec of changes in state of rocket
  % t is time elapsed -> scalar
  % state is column vec of current state of rocket
  % Created : Oct 31, 2016
  % Modfied : Oct 31, 2016
  % state    -> [x, z, m, V, Theta, Vol_air]
  % x, z     -> spacial coords (downrange and vertical) [meters]
  % m        -> mass                                    [kg]
  % V        -> speed                                   [m/s]
  % Theta    -> angle of V above the the horizontal     [radians]
  % Vol_air  -> volume of air in bottle                 [m^3]
  % T        -> temperature of air in bottle            [degrees K]
  % deltas = [dx, dz, dm, dV, dTheta, dVol_air]'
  % INPUTS : t, the current timestamp
  %          state, a vector of the currrent conditions the rocket is under
  % RETURNS: none
  % OUTPUTS: none
  % Assumes: that variables given to the equation are accurage
  % Given  : variables in 'globals,m'

  x       = state(1); % import current conditions
  z       = state(2);
  m       = state(3);
  V       = state(4);
  Theta   = state(5);
  Vol_air = state(6);
  m_air = state(7);

  if z <= 0 % if the rocket has hit the ground
    deltas = [0, 0, 0, 0, 0, 0, 0]'; % all changes are zero (it stays where it is)
    return;
  end


  %%%%%%%%%% Constants %%%%%%%%%%
  global g; % global variables defined in `globals.m`. Need to be imported thusly
  global c_disch;
  global rho_atmo;
  global Vol_bottle;
  global P_amb;
  global g_air;
  global rho_w;
  global D_t; % diameter of throat
  global A_t;
  global D_bottle; % diameter of bottle
  global Area_bottle;
  global R;
  global m_empty;
  global T0;
  global Cd;
  global P0;
  global Vol_water_0;
  global Vol_air_0;

  global m_air_0;
  global V0;
  global Theta0;
  global x0;
  global z0;
  global tmax;
  global m0;

  D = (1/2)*rho_atmo*(V^2) * Cd * Area_bottle; % Drag. Drag never changes
  P_water_phase = P0*(Vol_air_0/Vol_air)^1.4;  % Pressure during the water phase depends on the volume of air

  P_end   = P0*(Vol_air_0/Vol_bottle)^1.4;
  T_end   = T0*(Vol_air_0/Vol_bottle)^(1.4-1);
  P_air   = P_end*(m_air/m_air_0)^1.4; % pressure during the air phase depends on the mass of air
  rho_air = m_air/Vol_bottle;
  T       = P_air/(rho_air*R);
  P_crit  = P_air*(2/2.4)^(1.4/0.4);

  if (Vol_air < Vol_bottle) % WATER THRUST
    dmAir    = 0;
    dm       = -c_disch*A_t*sqrt( 2*rho_w*(P_water_phase-P_amb) );
    F        =  2*c_disch*(P_water_phase - P_amb)*A_t; % force of water exiting bottle
    dVol_air = c_disch*A_t*sqrt( (2/rho_w)*(P_water_phase-P_amb) );

  elseif P_air > P_amb         % AIR THRUST
    % check for choked flow
    if P_crit > P_amb % choked
      P_e   = P_crit;          % pressure at the exit is the critical pressure
      T_e   = 2/(2.4)*T;       % temperature
      V_e   = sqrt(1.4*R*T_e); % velocity is mach 1 (temperature at exit derived from temp in bottle)
      rho_e = P_e/(R * T_e);   % density from ideal gas equation
    else % unchoked
      P_e   = P_amb;                                 % pressure at the exit is ambient pressure
      M_e   = sqrt( (2/0.4)*( ((P_air/P_amb)^(0.4/1.4)) - 1)); % calculate mach number from pressure ratio
      T_e   = T * (1 + (0.4/2)*(M_e^2));             % calc temperature at exit from mach number, isentropic relations
      V_e   = M_e * sqrt(1.4*R*T_e);                 % calculate velocity from mach number
      rho_e = P_amb/(R * T_e);                       % density from ideal gas equation
    end

    dm       = 0;
    dmAir    = -c_disch*rho_e*A_t*V_e;
    F        = -dmAir*V_e+(P_e-P_amb)*A_t;
    dVol_air = 0;

  else % NO THRUST
    F        = 0;
    dVol_air = 0;
    dm       = 0;
    dmAir    = 0;
  end

  %%%%%%%%%% Unchanging Differential Equations %%%%%%%%%%
  dTheta = -g*cos(Theta)/V;
  if V <= 1 % if the rocket isn't going fast enough, assume it's still on the rails
    dTheta = 0;
  end
  dx     = V*cos(Theta);
  dz     = V*sin(Theta);
  dV     = (F - D -m*g*sin(Theta))/m; % a = sum(forces)/mass
  deltas = [dx, dz, dm, dV, dTheta, dVol_air, dmAir]'; % return a vector of the changes that occured
end                                                    % in this timestep
