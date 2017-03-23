function conf = get_cfg()
  % EDITING THIS FILE: Be sure to change the names everywhere
  % Values only have to be changed in one place.
  % This function returns a struct which contains all the fields seen below

  g           = 9.81;                        % [m/s^2]
  c_disch     = 0.8;                         % scalar
  rho_atmo    = 0.961;                       % air density [kg/m^3]
  vol_bottle  = 0.002;                       % volume of air, [m^3] should be less than vol_bottle
  P_amb       = toPa(12.03);                 % ambient pressure [Pa]
  g_air       = 1.4;                         % gas constant (Cv/Cp)
  rho_w       = 1000;                        % [kg/m^3]
  D_t         = 2.1/100;                     % diameter of throat [m]
  A_t         = (pi/4)*(D_t^2);              % area of throat [m^2]
  bottle_diam = 10.5/100;                    % diameter of bottle [m]
  bottle_area = (pi/4)*(bottle_diam^2);      % area of bottle [m^2]
  R           = 287;                         % [J/(kg*K)]
  m_empty     = 0.07;                        % [kg]
  T0          = 300;                         % 27 degree C day (300K)
  Cd          = 0.303238;                    % drag cooefienct
  P0          = toPa(66.99) + P_amb;         % 50 psi gage
  Vol_water_0 = 0.001;                       % [m^3]
  vol_air0    = vol_bottle - Vol_water_0;    % [m^3]

  m0     = m_empty + Vol_water_0*rho_w; % empty mass plus mass of water
  m_air0 = vol_air0*P0/(R*T0);                         % volume of air times density of air V*(P/RT)
  v0     = 0;                                          % must be greater than 0 [m/s]
  pitch0 = pi/4;                                       % radians
  hdg0   = 0;                                          % degrees
  tmax   = 10;                                         % seconds
  x0     = 0;                                          % meters
  y0     = 0;                                          % meters
  z0     = 0.1;                                        % meters
  coords0 = [x0 y0 z0];
  launch_angle = 45;                                   % degress
  vel0   = 0.1*[cosd(launch_angle) 0 sind(launch_angle)];% launch along x-y plane
  wind   = [0 0 0];                                    % m/s vector

  conf = struct( ...
    'g',           g,           ...
    'c_disch',     c_disch,     ...
    'rho_atmo',    rho_atmo,    ...
    'vol_bottle',  vol_bottle,  ...
    'P_amb',       P_amb,       ...
    'g_air',       g_air,       ...
    'rho_w',       rho_w,       ...
    'D_t',         D_t,         ...
    'A_t',         A_t,         ...
    'bottle_diam', bottle_diam, ...
    'bottle_area', bottle_area, ...
    'R',           R,           ...
    'm_empty',     m_empty,     ...
    'T0',          T0,          ...
    'Cd',          Cd,          ...
    'P0',          P0,          ...
    'Vol_water_0', Vol_water_0, ...
    'vol_air0',    vol_air0,    ...
    'm0',          m0,          ...
    'm_air0',      m_air0,      ...
    'v0',          v0,          ...
    'pitch0',      pitch0,      ...
    'hdg0',        hdg0,        ...
    'tmax',        tmax,        ...
    'wind',        wind,        ...
    'coords0',     coords0,     ...
    'vel0',        vel0         ...
  );
end
