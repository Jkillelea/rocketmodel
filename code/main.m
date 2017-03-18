% UID 4e841e99f297
% Created : Oct 31, 2016
% Modfied : Nov 29, 2016
% This is script is the starting point for the rocket simulation.
% Should run by itself, no input parameters needed.
% It calls the functions 'globals.m', 'rocket.m', and 'ode45'.
% INPUTS : none
% RETURNS: none
% OUTPUTS: text of max height and range, graph of rocket flight
% Given  : variables in 'globals,m'

clear all;
close all;
clc;

% Assumes constants defined in 'globals.m' are accurate
%%%%%%%%%% Constants %%%%%%%%%%
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

% Call ode45 with the inital conditions
inital_conds = [x0, z0, m0, V0, Theta0, Vol_air_0, m_air_0];
[t, y] = ode45('rocket', [0, tmax], inital_conds);

% figure; hold on;
% labels = [{'x'}, {'z'}, {'m'}, {'velocity'}, {'theta'}, {'volume'}, {'air mass'}];
% for i = [2, 3, 4]
% % for i = [4, 5]
%   plot(t, y(:, i), 'DisplayName', labels{i});
%   legend('show')
% end

% Find where the rocket hits the ground
impact_index = find(y(:, 2) <= 0, 1, 'first');
max_x = y(impact_index, 1);
% Print it out
fprintf('Max Z: %f\n', max(y(:, 2)));
fprintf('Max X: %f\n', y(impact_index, 1));

% Plot the flightpath of the rocket
figure; hold on;
axis([0 100 0 40])
plot(y(:, 1), y(:,2));
set(get(gca,'Title'),'String','Flight Path of Rocket');
set(get(gca,'XLabel'),'String','Downrange distance, x (m)');
set(get(gca,'YLabel'),'String','Vertical distance, z (m)');
