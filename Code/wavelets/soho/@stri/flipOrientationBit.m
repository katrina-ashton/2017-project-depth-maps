function st = flipOrientationBit( st)
%
% st = flipOrientation( st)
%
% Flip the orientation bit of the spherical triangle
  
  st.orientation = -1.0 * st.orientation;

end