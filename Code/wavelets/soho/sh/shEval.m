function sample = shEval( l, m, theta, phi)
%
% function sample = shEval( l, m, theta, phi)
%
% Evaluate the (l,m)-th SH basis function at (theta,phi)

  if( 0 == m)
    sample = shNormalize(l,0) * shLegendre(l,m,cos(theta));
  elseif (m > 0)
    sample = ...
      sqrt(2) * shNormalize(l,m) * cos(m * phi) * shLegendre(l,m,cos(theta));
  else
    sample = ...
      sqrt(2) * shNormalize(l,-m) * sin(-m *phi) * shLegendre(l,-m, cos(theta));
  end

end