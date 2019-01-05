function [m, n] = findLineEquation2D( v0, v1)
%
% [m, n] = findLineEquation2D( v0, v1)
%
% Compute equation of line spanned by the two vertices (in 2D)

  condition( ( size( v0, 1) == 2) && ( size( v1, 1) == 2));

  m = (v0(2) - v1(2)) / (v0(1) - v1(1));
  
  n = v0(2) - m * v0(1);
  
  % sanity check, both points have to satisfy the equation
  epsilon = 10^-8;
   
  checkEpsilon( v0(2) - (m * v0(1) + n), epsilon);
  checkEpsilon( v1(2) - (m * v1(1) + n), epsilon);  
  
end
