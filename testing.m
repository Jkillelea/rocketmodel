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

clear;
close all;
clc;
addpath(genpath('.'));

% test water volume
[water_range, water_vol] = test_water;
[max_water_range, idx]   = max(water_range);
max_water                = water_vol(idx);

fprintf('max range at water volume of %f m^3.\n', max_water);

figure;
scatter(water_vol, water_range);
xlabel('water volume, m^3');
ylabel('downrange distance, m');


% test launch angle
[angle_range, angle]   = test_angle;
[max_angle_range, idx] = max(angle_range);
max_angle              = angle(idx);

fprintf('max range at angle of %d degrees.\n', max_angle);

figure;
scatter(angle, angle_range);
xlabel('angle, degrees');
ylabel('downrange distance, m');


% test mass
[mass_range, mass]    = test_mass;
[max_mass_range, idx] = max(angle_range);
max_mass              = mass(idx);

fprintf('max range at empty mass %f kg.\n', max_mass);

figure;
scatter(mass, mass_range);
xlabel('mass, kg');
ylabel('downrange distance, m');
