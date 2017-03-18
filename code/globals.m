function globals()
  % UID 4e841e99f297
  % Created : Oct 31, 2016
  % Modfied : Oct 31, 2016
  % Handles creation of global variables for the rocket simulation.
  % INPUT   : NONE
  % RETURNS : NONE
  % OUTPUTS : NOTHING

  global g;       % define variable as global. To be used in another context, the variable needs to be
  global c_disch; % called like this again. Its value is assigned below.
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
  global m0;
  global V0;
  global Theta0;
  global x0;
  global z0;
  global tmax;

  g           = 9.81;                        % [m/s^2]
  c_disch     = 0.8;                         % scalar
  rho_atmo    = 0.961;                       % air density [kg/m^3]
  Vol_bottle  = 0.002;                       % volume of air, [m^3] should be less than Vol_bottle
  P_amb       = toPa(12.03);                 % ambient pressure [Pa]
  g_air       = 1.4;                         % gas constant (Cv/Cp)
  rho_w       = 1000;                        % [kg/m^3]
  D_t         = 2.1/100;                     % diameter of throat [m]
  A_t         = (pi/4)*(D_t^2);              % area of throat [m^2]
  D_bottle    = 10.5/100;                    % diameter of bottle [m]
  Area_bottle = (pi/4)*(D_bottle^2);         % area of bottle [m^2]
  R           = 287;                         % [J/(kg*K)]
  m_empty     = 0.07;                        % [kg]
  T0          = 300;                         % 27 degree C day (300K)
  Cd          = 0.303238;                    % drag cooefienct
  P0          = toPa(66.99) + P_amb;         % 50 psi gage
  Vol_water_0 = 0.001;                       % [m^3]
  Vol_air_0   = Vol_bottle - Vol_water_0;    % [m^3]

  m0          = m_empty + Vol_water_0*rho_w; % empty mass plus mass of water
  m_air_0     = Vol_air_0*P0/(R*T0);         % volume of air times density of air V*(P/RT)
  V0          = 0;                           % must be greater than 0 [m/s]
  Theta0      = pi/4;                        % radians
  x0          = 0;                           % meters
  z0          = 0.1;                         % meters
  tmax        = 5;                           % seconds
  % tmax        = 0.2;                       % seconds
end
