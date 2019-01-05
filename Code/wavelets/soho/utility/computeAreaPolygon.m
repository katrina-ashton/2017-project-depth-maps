function a = computeAreaPolygon( verts)
%
% a = computeAreaPolygon( verts)
%
% Compute the area of a polygon those vertices are sorted / orientated CW or CCW
% 
% @return  area of the polygon
% @param  verts  vertices spanning the polygon

  % expecting closed polygon
  condition( 1 == all( verts(:,1) == verts(:,end)));
  
  verts_tri(:,1) = verts(:,1);
  
  a = 0;
  for( i = 2 : (size( verts,2) - 2))
    
    verts_tri(:,2) = verts(:,i);
    verts_tri(:,3) = verts(:,i+1);
    
    a = a + computeAreaTrianglePlanar( verts_tri);  
    
  end

end