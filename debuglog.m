function debuglog(string)
  global DEBUG_LOG;
  if DEBUG_LOG
    disp(['[DEBUG]: ', string]);
  end
end
