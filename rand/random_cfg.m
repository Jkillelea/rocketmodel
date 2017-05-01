function conf = random_cfg
  % generate a pseudorandom config
  addpath(genpath('../'));
  conf = get_cfg;
  errors = sigmas;
  fieldnames = fields(errors);

  for i = 1:length(fieldnames)
    field = fieldnames{i};
    conf.(field) = conf.(field) + plus_minus(errors.(field));
  end
end
