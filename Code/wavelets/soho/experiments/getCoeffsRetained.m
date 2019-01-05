function coeffs = getCoeffsRetained( level)
%
% coeffs = getCoeffsRetained( level)
% 
% Get a list of different numbers of coefficients to retain for a signal
% defined on level \a level
%
% @param level   level on which the signal is defined

  coeffs = [];

  if( 3 == level)
    coeffs = [32 64 128 256];
  elseif( 5 == level)
    coeffs = [32 64 128 256 512 1024 2056];
  elseif( 6 == level)
    coeffs = [64 256 512 1024 1536 2056 2568 3080];
  % elseif( 7 == level)
  % coeffs = [64 256 512 1024 2056 4096 8192 16384 32768];    
  elseif( 7 == level)
    % for SH comparison experiments
    for( i = 3 : 25)
      coeffs = [coeffs i^2];
    end
  else
    error( 'Level not supported');
  end

end