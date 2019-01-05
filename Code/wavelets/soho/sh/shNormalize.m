function n = shNormalize( l, m)
%
% function n = shNormalize( l, m)
%
% Normalization constant for SH basis function

  n = ((2 * l + 1.0) * factorial(l-m)) / (4 * pi * factorial(l+m));
  n = sqrt( n);

end