function cfg = get_cfg_w_launch_angle(launch_angle)
  % TAKES ANGLE IN DEGREES
  % EDITING THIS FILE: Be sure to change the names everywhere
  % Values only have to be changed in one place.
  % This function returns a struct which contains all the fields seen below

  cfg = get_cfg;

  cfg.launch_angle = launch_angle;
  cfg.vel0 = 0.3*[cosd(launch_angle) 0 sind(launch_angle)];% launch along x-y plane
end
