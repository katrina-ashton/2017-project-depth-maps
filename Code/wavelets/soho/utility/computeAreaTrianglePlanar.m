function a = computeAreaTrianglePlanar( verts)
%
% a = computeAreaTrianglePlanar( verts)
%
% Compute the area of a planar triangle specified by its vertices \a verts
% @return  area of the triangle
% @param  verts  vertices of the triangle

  e0 = verts(:,2) - verts(:,1); 
  norm_e0 = norm(e0);
  e0 = e0 / norm_e0;
  e1 = verts(:,3) - verts(:,1); 
  norm_e1 = norm(e1);
  e1 = e1 / norm_e1;

  sin_gamma = sin( acos( dot( e0, e1)));
  a = 0.5 * norm_e0 * norm_e1 * sin_gamma;

end