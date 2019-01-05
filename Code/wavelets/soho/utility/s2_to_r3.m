function r3 = s2_to_r3( s2)
%
% r3 = s2_to_r3( s2)
%
% Convert from spherical coordinates in S^2 to euclidean coordinates in R^3
%
% @return column vector with coordinates in R^3 (unit vector)
% @param  s2 = [theta; phi]  coordintaes on S^2

  theta = s2( 1);
  phi = s2(2);

  sin_theta = sin(theta);
  
  r3 = [];
  r3(1) = cos(phi) * sin_theta;
  r3(2) = sin(phi) * sin_theta;  
  r3(3) = cos(theta);

  r3 = r3';
  
end
