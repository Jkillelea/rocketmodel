function results = rocket(~, conds)
  coords  = conds(1:3)'; % x y z coords
  vel_vec = conds(4:6)'; % x y z velocity
  m       = conds(7); % current total mass
  vol_air = conds(8); % air volume
  m_air   = conds(9); % air mass

  if coords(3) < 0 % if rocket has hit the ground return all zeros (frozen)
    results = zeros(length(conds), 1);
    return
  end

  % import config
  cfg  = get_cfg;
  g    = cfg.g;
  wind = cfg.wind;

  if norm(coords) < 0.5 % if we haven't gone very far, ignore wind and gravity (still on rails)
    wind = 0;
    g    = 0;
  end

  relative_vel  = vel_vec - wind;
  dir_vec       = relative_vel ./ norm(relative_vel);
  drag          = drag_calc(norm(relative_vel))*dir_vec;

  [f_thrust, dvol_air, dm, dm_air] = thrust_calc(vol_air, m_air, cfg); % all the painful equations are here

  thrust    = f_thrust*dir_vec;
  accel_vec = (thrust - drag - m*[0 0 g])/m;

  % keep track of thrust over time
  global thrust_list;
  thrust_list(end+1) = f_thrust;

  results = [vel_vec, accel_vec, dm, dvol_air, dm_air]'; % [dx dy dz, ax ay az, dm, dvol_air, dm_air]
end
