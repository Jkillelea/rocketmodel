% This is script is the starting point for the rocket simulation.
% Should run by itself, no input parameters needed.
% It calls the functions 'globals.m', 'rocket.m', and 'ode45'.
% INPUTS : none
% RETURNS: none
% OUTPUTS: text of max height and range, graph of rocket flight
% Given  : variables in 'globals,m'

clear;
close all;
clc;

%%%%%%%%%% Constants %%%%%%%%%%
cfg = get_cfg();

coords0  = cfg.coords0;
vel0     = cfg.vel0;
m0       = cfg.m0;
v0       = cfg.v0;
hdg0     = cfg.hdg0;
pitch0   = cfg.pitch0;
vol_air0 = cfg.vol_air0;
m_air0   = cfg.m_air0;
tmax     = cfg.tmax;

inital_conds = [coords0, vel0, m0, vol_air0, m_air0];
[t, res] = ode45('rocket', [0, tmax], inital_conds, cfg);

% Find where the rocket hits the ground
impact_index = find(res(:, 3) <= 0, 1, 'first');
max_x        = res(impact_index, 1);

% Print it out
fprintf('Max Z: %f\n', max(res(:, 3)));
fprintf('Max X: %f\n', res(impact_index, 1));

% Plot the flightpath of the rocket
figure; hold on; grid on; axis equal;
% axis([0 100 0 40])
% plot(res(:, 1), res(:,3));
plot3(res(:, 1), res(:, 2), res(:,3));
xlabel('Downrange Distance x (m)');
ylabel('Crossrange Distance y (m)');
zlabel('Vertical Distance z (m)');
