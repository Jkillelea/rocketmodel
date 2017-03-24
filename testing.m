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
addpath(genpath('.'));

[water_range, water_vol] = test_water;
[max_range, idx]         = max(water_range);
max_water                = water_vol(idx);

fprintf('max range at water volume of %f m^3.\n', max_water);

figure;
plot(water_vol, water_range);
xlabel('water volume, m^3');
ylabel('downrange distance, m');


[angle_range, angle]   = test_angle;
[max_angle_range, idx] = max(angle_range);
max_angle              = angle(idx);

fprintf('max range at angle of %d.\n', max_angle);

figure;
plot(angle, angle_range);
xlabel('angle, degrees');
ylabel('downrange distance, m');

