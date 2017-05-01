function results = rocket(t, conds, cfg)
  % Check to see if we've gone over the maximum number of attempts
  global ATTEMPT_MAX ATTEMPT_NUMBER
  if ATTEMPT_NUMBER >= ATTEMPT_MAX
    throw('ATTEMPT ABORTED')
  end
  ATTEMPT_NUMBER = ATTEMPT_NUMBER + 1;

  coords  = conds(1:3)'; % x y z coords
  vel_vec = conds(4:6)'; % x y z velocity
  m       = conds(7); % current total mass
  vol_air = conds(8); % air volume
  m_air   = conds(9); % air mass

  if coords(3) < 0 % if rocket has hit the ground return all zeros (frozen)
    % debuglog('hit ground');
    results = zeros(length(conds), 1);
    return
  end

  % import config
  g    = cfg.g;
  wind = cfg.wind;

  if norm(coords) < 0.606 % if we haven't gone very far, ignore wind and gravity (still on rails)
    wind = 0;
    g    = 0;
  end

  relative_vel  = vel_vec - wind;
  dir_vec       = relative_vel ./ norm(relative_vel);
  drag          = drag_calc(norm(relative_vel), cfg)*dir_vec;


  %%%%%%%%%% Force Curve %%%%%%%%%%
  [f_thrust, dvol_air, dm, dm_air] = thrust_calc(vol_air, m_air, cfg); % all the painful equations are here

  % global force_accumulator;
  % force_accumulator(end+1, :) = [t, f_thrust];

  thrust    = f_thrust*dir_vec;
  accel_vec = (thrust - drag - m*[0 0 g])/m;

  results = [vel_vec, accel_vec, dm, dvol_air, dm_air]'; % [dx dy dz, ax ay az, dm, dvol_air, dm_air]
end
