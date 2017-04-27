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

clear; close all; clc;
addpath(genpath('.'));

% test water volume
disp('Water:');
[water_range, water_vol] = test_water;
[max_water_range, idx]   = max(water_range);
max_water                = water_vol(idx);
disp(' ');
fprintf('max range at water volume of %f m^3.\n', max_water);

fig = figure;
scatter(water_vol, water_range);
title('Water Volume vs Distance');
xlabel('water volume, m^3');
ylabel('downrange distance, m');
print(fig, '-dpng', 'water_vol_test');


% test launch angle
disp('Angle');
[angle_range, angle]   = test_angle;
[max_angle_range, idx] = max(angle_range);
max_angle              = angle(idx);
disp(' ');
fprintf('max range at angle of %d degrees.\n', max_angle);

fig = figure;
scatter(angle, angle_range);
title('Angle vs Distance');
xlabel('angle, degrees');
ylabel('downrange distance, m');
print(fig, '-dpng', 'angle_test');


% test mass
disp('Mass');
[mass_range, mass]    = test_mass;
[max_mass_range, idx] = max(mass_range);
max_mass              = mass(idx);
disp(' ');
fprintf('max range at empty mass %f kg.\n', max_mass);

fig = figure;
scatter(mass, mass_range);
title('Empty Mass vs Distance');
xlabel('mass, kg');
ylabel('downrange distance, m');
print(fig, '-dpng', 'mass_test');

% test mass
disp('Cd');
[cd_range, cd]      = test_cd;
[max_cd_range, idx] = max(cd_range);
max_cd              = cd(idx);
disp(' ');
fprintf('max range at cd = %f\n', max_cd);

fig = figure;
scatter(cd, cd_range);
title('C_d vs Distance');
xlabel('C_d');
ylabel('downrange distance, m');
print(fig, '-dpng', 'cd_test');
