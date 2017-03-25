% This is script is the starting point for the rocket simulation.
% Should run by itself, no input parameters needed.
% It calls the functions 'globals.m', 'rocket.m', and 'ode45'.
% INPUTS : none
% RETURNS: none
% OUTPUTS: text of max height and range, graph of rocket flight
% Given  : variables in 'conf/get_cfg.m'
clear; close all; clc;
addpath(genpath('.'));

%%%%%%%%%% Constants %%%%%%%%%%
cfg = get_cfg;
coords0  = cfg.coords0;
vel0     = cfg.vel0;
m0       = cfg.m0;
v0       = cfg.v0;
hdg0     = cfg.hdg0;
vol_air0 = cfg.vol_air0;
m_air0   = cfg.m_air0;
tmax     = cfg.tmax;
wind     = cfg.wind;

inital_conds = [coords0, vel0, m0, vol_air0, m_air0];
[t, res] = ode45('rocket', [0, tmax], inital_conds, cfg);

% Find where the rocket hits the ground
coords = res(:, 1:3);
impact_index = find(coords(:, 3) <= 0, 1, 'first');
max_x        = coords(impact_index, 1);
impact_pt    = coords(impact_index, :);

% Print it out
fprintf('Max X = %f\n', impact_pt(1));
fprintf('Max Z = %f\n', max(coords(:, 3)));
fprintf('Downrange distance %f meters\n', norm(impact_pt(1:2)));

% Plot the flightpath of the rocket
figure; hold on; grid on; axis equal;

plot3(res(:, 1), res(:, 2), res(:,3));
plot3([0, impact_pt(1)], [0, impact_pt(2)], [0, impact_pt(3)]);
quiver3(0, 0, 0, wind(1), wind(2), wind(3));

xlabel('Downrange Distance x (m)');
ylabel('Crossrange Distance y (m)');
zlabel('Vertical Distance z (m)');
