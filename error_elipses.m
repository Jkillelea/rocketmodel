% generate error elipses
clear; clc; close all;
global DEBUG_LOG;
DEBUG_LOG = false;
addpath(genpath('.'));

NUM_TERATIONS = 25;
results       = zeros(NUM_TERATIONS, 2); % x and y coords

for i = 1:NUM_TERATIONS
  cfg = random_cfg;

  inital_conds = [cfg.coords0, cfg.vel0, cfg.m0, cfg.vol_air0, cfg.m_air0];
  [t, res]     = ode45(@(t, y) rocket(t, y, cfg), [0, cfg.tmax], inital_conds, cfg);
  coords       = res(:, 1:3);
  impact_index = find(coords(:, 3) <= 0, 1, 'first');
  max_x        = coords(impact_index, 1);
  impact_pt    = coords(impact_index, :);

  % HACK THIS SO IT CHECK IF impact_pt IS AT LEAST 3 ELEMNETS (X, Y, Z) AND IF NOT RESTARTS JUST
  % THAT ITERATION OF THE LOOP
  if length(impact_pt) < 3
    continue
  end
  results(i, :) = impact_pt(1:2); % save x and y
  disp(sprintf('%d/%d\n', i, NUM_TERATIONS));
end
fprintf('\n');


% ignore results where we go negative range or go nowhere
selector = results(:, 1) > 0;
results = results(selector, :);

% plot landing points
fig = figure; hold on;
xlabel('Crossrange Distance [meters]');
ylabel('Downrange Distance [meters]');
for i = 1:length(results)
  point = results(i, :);
  scatter(results(i, 2), results(i, 1))
end

% get covariance matrix
y = results(:, 1); % note that x and y are swapped from before so that they're the downrange (y) and
                   % crossrange (x) values.
x = results(:, 2);

% Calculate covariance matrix
P      = cov(x, y);
mean_x = mean(x);
mean_y = mean(y);

% Calculate the define the error ellipses
n = 100; % Number of points around ellipse
p = 0:pi/n:2*pi; % angles around a circle
[eigvec, eigval] = eig(P); % Compute eigen-stuff
xy_vect = [cos(p'),sin(p')] * sqrt(eigval) * eigvec'; % Transformation
x_vect  = xy_vect(:, 1);
y_vect  = xy_vect(:, 2);

% Plot the error ellipses overlaid on the same figure
plot(1*x_vect+mean_x, 1*y_vect+mean_y, 'b')
plot(2*x_vect+mean_x, 2*y_vect+mean_y, 'g')
plot(3*x_vect+mean_x, 3*y_vect+mean_y, 'r')

print(fig, 'error_elipses_mk2', '-dpng');
