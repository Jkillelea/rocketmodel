format shortG
files    = dir('Group*');
numfiles = length(files);

Isp          = zeros(numfiles, 1);
MaxT         = zeros(numfiles, 1);
Time_Elapsed = zeros(numfiles, 1);

for i = 1:numfiles
  fname = files(i).name;
  data = load(fname);
  disp(fname)

  % sampling size frequency is 1.652 kHz so time can be computed for the x-axis
  % z is the summation of the two load cells
  time = (1:length(data))./1652;
  time = time(:);
  z    = data(:, 3);

  % finds the minimum index for time
  [mz, min_indicies] = min(z);
  t_end = time(min_indicies);

  % finds the start so it can be integrated
  dz       = diff(z);
  indicies = find(dz > 1);

  % find point where water cuts out in order to correct for sensor screwyness
  min_val = min(z);
  lower_peaks = find(z < 0.6*min_val);

  % this is range of data points for which the rocket is actually firing
  start_point = indicies(1);
  last_peak   = lower_peaks(end);

  % get slope of the line between the start and end point for correction (both should be at zero)
  x1   = start_point;    x2 = last_peak;
  y1   = z(start_point); y2 = z(last_peak);
  m    = (y2 - y1) / (x2 - x1);
  line = @(x) z(start_point) + m.*(x - x1);

  % subtract this from the relevant section of the line so that the start and end points are both zero
  % and truncate the data since this is the only section we care about
  span = start_point:last_peak;
  z    = z(span) - line(span)';
  time = time(span);

  % plot things
  figure; hold on;
  plot(time, z);
  plot(time(1), z(1), 'go')
  plot(time(end),   z(end),   'ro')

  % integrate the force curve for total impulse
  impulse = trapz(time, z);

  % divide by weight of propellant for specific impulse
  Isp(i)          = impulse./(9.81);
  MaxT(i)         = Isp(i).*(1000/time(i)).*8.91;
  Time_Elapsed(i) = time(i);

  % should give the standard deviation
  val = std2(data);
  %population is 12000
  n = 12000;

  x_bar = val./sqrt(n);
end
