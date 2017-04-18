clear; close all; clc;
format shortG;
addpath(genpath('.'));

cfg  = get_cfg;
area = cfg.bottle_area;


data = load('WTData.csv');
q  = data(:,  5);
Fd = data(:, 25);

% remove points where wind isn's on
select = q > 10;
q      = q(select);
Fd     = Fd(select);

cd = Fd./(q*area);

fprintf('cd %f (sigma %f)\n', mean(cd), std(cd));
