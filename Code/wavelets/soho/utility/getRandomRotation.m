function [R , axis , angle] = getRandomRotation()
%
% [R , axis , angle] = getRandomRotation()
%
% Generate a random rotation 
%
% @return R  [3x3] rotation matrix corresponding to the generated rotation
% @retrun axis  rotation axis of the generated rotation
% @return angle  rotation angle around \a axis

  % initalize random number generator
  rand('state',sum(100*clock));  

  axis = rand(3,1);
  axis = (axis - 0.5) * 2.0;
  axis = axis / norm(axis);
  
  angle = rand * 360;
  
  R = getRotationMatrix( axis, angle);
  
end