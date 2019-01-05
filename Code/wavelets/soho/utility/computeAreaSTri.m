function a = computeAreaSTri( verts)
%
%  a = computeArea( verts)
%
% Compute the area of a spherical triangle defined on the unit sphere
%
% @return  a  area
% @param  verts  vertices of the spherical triangle in euclidean
%                   coordinates

  % compute the cosine of the angular length of the sides of the spherical 
  % triangle
  % the sides are defined in the standard way, i.e. e1 with |e1| = l1 is 
  % opposite to v1 = a and therefore spanned by v2 = b and v3 = c
  % formula: http://mathworld.wolfram.com/SphericalDistance.html
  cos_a = dot( verts(:,2), verts(:,3));
  cos_b = dot( verts(:,3), verts(:,1));  
  cos_c = dot( verts(:,1), verts(:,2));  
  % cache some more values
  sin_a = sin( acos( cos_a));
  sin_b = sin( acos( cos_b));
  sin_c = sin( acos( cos_c));  
  
  if(     ( 0 == (sin_b * sin_c)) || ( 0 == (sin_c * sin_a)) ...
       || ( 0 == (sin_a * sin_b)) )
    a = 0;
    return;
  end
  
  % compute the diphedral angles of the spherical triangle (angle between
  % the planes of the great arcs)
  alpha_a = acos( (cos_a - cos_b * cos_c) / (sin_b * sin_c));
  alpha_b = acos( (cos_b - cos_c * cos_a) / (sin_c * sin_a));
  alpha_c = acos( (cos_c - cos_a * cos_b) / (sin_a * sin_b));  
  
  % for the unit sphere the area is identical to the spherical excess  
  a = ((alpha_a + alpha_b + alpha_c) - pi);
  
end
