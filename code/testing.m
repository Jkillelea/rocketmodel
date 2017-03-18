% UID 4e841e99f297
% Created : Nov 28, 2016
% Modfied : Nov 28, 2016
% This script tests for the most sensitive parameter among the following:
% Initial launch angle, Theta0
% Initial water volume, Vol_water_0
% Initial pressure, P0
% INPUTS : none
% RETURNS: none
% OUTPUTS: text and graphs of best parameters for rocket range, rate of change of parameters
% Given  : variables in 'globals.m' are accurate
% Assumes: testing ranges are correctly sized, the value of the variable 'resolution' is high enough to
%          capture good data.

clear all;
close all;
clc;

%%%%%%%%%% Define and import global variables %%%%%%%%%%
globals(); % global variables defined in `globals.m`. Need to be imported thusly
global g;
global c_disch;
global rho_atmo;
global Vol_bottle;
global P_amb;
global g_air;
global rho_w;
global D_t;
global A_t;
global D_bottle;
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

%%%%%%%%%% Define possible ranges for variables %%%%%%%%%%
resolution        = 50;          % number of intervals to try
range_Theta0      = [0, pi/2];   % radians
range_Vol_water_0 = [0, 0.0013]; % m^3
range_P0          = [10, 80];    % psi

vals_Theta0      = linspace(range_Theta0(1),      range_Theta0(2),      resolution); % linearly spaced values between the first and second numbers
vals_Vol_water_0 = linspace(range_Vol_water_0(1), range_Vol_water_0(2), resolution);
vals_P0          = linspace(range_P0(1),          range_P0(2),          resolution);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% test variation in theta values
disp('Testing Theta...');
xmax_theta = [];
for i = 1:resolution
  Theta0 = vals_Theta0(i);

  inital_conds = [x0, z0, m0, V0, Theta0, Vol_air_0, m_air_0];
  [t, y] = ode45('rocket', [0, tmax], inital_conds);

  xmax_theta(i) = max(y(:, 1)); % find max range
  if ~isreal(xmax_theta(i)) % if xmax_theta isn't real just set to zero
    xmax_theta(i) = 0;
  end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% test variation in volume of water. Affects volume and mass of air, mass of rocket
globals(); % reset global variables

xmax_vol = [];
disp('Testing Volume...');
for i = 1:resolution
  Vol_water_0 = vals_Vol_water_0(i);
  Vol_air_0   = Vol_bottle - Vol_water_0;
  m0          = m_empty + Vol_water_0*rho_w;
  m_air_0     = Vol_air_0*P0/(R*T0);

  inital_conds = [x0, z0, m0, V0, Theta0, Vol_air_0, m_air_0];
  [t, y] = ode45('rocket', [0, tmax], inital_conds);

  xmax_vol(i) = max(y(:, 1)); % find max range
  if ~isreal(xmax_vol(i))     % if xmax_vol isn't real just set to zero
    xmax_vol(i) = 0;
  end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% test variation in volume of water. Affects volume and mass of air, mass of rocket
globals(); % reset global variables

xmax_pres = [];
disp('Testing Pressure...');
for i = 1:resolution
  P0      = toPa( vals_P0(i) ) + P_amb; % gage pressure, converted from PSI to Pa
  m_air_0 = Vol_air_0*P0/(R*T0);

  inital_conds = [x0, z0, m0, V0, Theta0, Vol_air_0, m_air_0];
  [t, y] = ode45('rocket', [0, tmax], inital_conds);

  xmax_pres(i) = max(y(:, 1)); % find max range
  if ~isreal(xmax_pres(i))     % if xmax_pres isn't real just set to zero
    xmax_pres(i) = 0;
  end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[num_t, index_t] = max(xmax_theta);
[num_v, index_v] = max(xmax_vol);
[num_p, index_p] = max(xmax_pres);

fprintf('best theta: %.3f radians.\n',    vals_Theta0(index_t));
fprintf('best volume: %.4f m^3.\n',   vals_Vol_water_0(index_v));
fprintf('best pressure: %.3f psi.\n', vals_P0(index_p));

figure;
plot(vals_Theta0, xmax_theta)
set(get(gca,'Title'),'String',sprintf('Range vs Theta, %d iterations', resolution));
set(get(gca,'XLabel'),'String','Theta, (radians)');
set(get(gca,'YLabel'),'String','Range, x (meters)');

figure;
plot(vals_Vol_water_0, xmax_vol)
set(get(gca,'Title'),'String',sprintf('Range vs Water Volume, %d iterations', resolution));
set(get(gca,'XLabel'),'String','Volume, (m^3)');
set(get(gca,'YLabel'),'String','Range, x (meters)');

figure;
plot(vals_P0, xmax_pres)
set(get(gca,'Title'),'String',sprintf('Range vs Pressure, %d iterations', resolution));
set(get(gca,'XLabel'),'String','Pressure, (psi)');
set(get(gca,'YLabel'),'String','Range, x (meters)');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Evalute rate of change of max range as parameter changes
% dxmax_d(param)
dxmax_dtheta = abs(diff(xmax_theta));
dxmax_dvol   = abs(diff(xmax_vol));
dxmax_dpres  = abs(diff(xmax_pres));

figure;
plot(vals_Theta0(1:length(vals_Theta0)-1), dxmax_dtheta)
set(get(gca,'Title'),'String',sprintf('Rate of change of range with variation of launch angle, %d iterations', resolution));
set(get(gca,'XLabel'),'String','Launch angle theta (radians)');
set(get(gca,'YLabel'),'String','Change in range from previous (meters)');

figure;
plot(vals_Vol_water_0(1:length(vals_Vol_water_0)-1), dxmax_dvol)
set(get(gca,'Title'),'String',sprintf('Rate of change of range with volume of water, %d iterations', resolution));
set(get(gca,'XLabel'),'String','Volume of water (m^3)');
set(get(gca,'YLabel'),'String','Change in range from previous (meters)');

figure;
plot(vals_P0(1:length(vals_P0)-1), dxmax_dpres)
set(get(gca,'Title'),'String',sprintf('Rate of change of range with pressure, %d iterations', resolution));
set(get(gca,'XLabel'),'String','Gage pressure of bottle (psi)');
set(get(gca,'YLabel'),'String','Change in range from previous (meters)');

% find which parameter has the largest change from one step to the next
[num, index] = max([max(dxmax_dtheta), max(dxmax_dvol), max(dxmax_dpres)]);

switch index
  case 1
    fprintf('the most sensitive parameter is theta, the launch angle, with a max rate of change of %.3f.\n', num);
  case 2
    fprintf('the most sensitive parameter is the volume of water in the rocket, with a max rate of change of %.3f.\n', num);
  case 3
    fprintf('the most sensitive parameter is the pressure of the air in the bottle, with a max rate of change of %.3f.\n', num);
end
