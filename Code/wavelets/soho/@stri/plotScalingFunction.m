function plotScalingFunction( tri) 
%
% plotScalingFunction( tri) 
%
% Plot the scaling basis functions corresponding to the spherical triangle
% tri
%
% @param tri   spherical triangle those associate scaling function to plot

  % begin plotting

  a = 1.0 / sqrt( getArea( tri));
  a = a / 5;
  
  plotTriCurved( tri, 1.0 + a);
  
end