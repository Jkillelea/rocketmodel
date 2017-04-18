function [Vx,Vy] = convert_wind(Direction, Speed)
  % Converts measured wind to launch pad coordinate frame.
  % Direction must be a string in all

  %% Convert
  Speed = -Speed;
  if Direction == 'N'
      Vx = -Speed * cosd(30);
      Vy = -Speed * sind(30);
  elseif Direction == 'NE'
      Vx = -Speed * cosd(15);
      Vy = Speed * sind(15);
  elseif Direction == 'E'
      Vx = -Speed * cosd(60);
      Vy = Speed * sind(60);
  elseif Direction == 'SE'
      Vx = Speed * cosd(75);
      Vy = Speed * sind(75);
  elseif Direction == 'S'
      Vx = Speed * cosd(30);
      Vy = Speed * sind(30);
  elseif Direction == 'SW'
      Vx = Speed * cosd(15);
      Vy = -Speed * sind(15);
  elseif Direction == 'W'
      Vx = Speed * cosd(60);
      Vy = -Speed * sind(60);
  elseif Direction == 'NW'
      Vx = -Speed * cosd(75);
      Vy = -Speed * sind(75);
  elseif Direction == 'NNE'
      Vx = -Speed * cosd(7.5);
      Vy = -Speed * sind(7.5);
  elseif Direction == 'NEE'
      Vx = -Speed * cosd(37.5);
      Vy = Speed * sind(37.5);
  elseif Direction == 'SEE'
      Vx = -Speed * cosd(82.5);
      Vy = Speed * sind(82.5);
  elseif Direction == 'SSE'
      Vx = Speed * cosd(52.2);
      Vy = Speed * sind(52.5);
  elseif Direction == 'SSW'
      Vx = Speed * cosd(7.5);
      Vy = Speed * sind(7.5);
  elseif Direction == 'SWW'
      Vx = Speed * cosd(37.5);
      Vy = -Speed * sind(37.5);
  elseif Direction == 'NWW'
      Vx = Speed * cosd(82.5);
      Vy = -Speed * sind(82.5);
  elseif Direction == 'NNW'
      Vx = -Speed * cosd(52.2);
      Vy = -Speed * sind(52.5);
  end
end
