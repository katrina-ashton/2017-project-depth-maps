function [all_inside, inside] = allPointsInsideSTri( t0, t1)
% 
%  inside = allPointsInside( t0, t1)
%
% Check if all points of \a t1 are contained in \a t0 (which implies that
% the spherical triangle is contained in the first one)
%
% @return all_inside  1 if all vertices of \a t1 are inside \a t0, otherwise 0
% @return inside      vector which contains inside / outside relation for
%                     vertices
% @param  t0  spherical triangle
% @param  t1  spherical triangle those vertices are tested if they lie in
%             t1

  % get vertices
  t1_verts = getVertsEC( t1);
  
  % for all vertices
  inside = [];
  for( i = 1 : size( t1_verts, 2))
    inside(i) = checkPointInsideSTri( t0, t1_verts(:,i));
  end
  
  all_inside = 0;
  if( 3 == sum( inside))
    all_inside = 1;
  end

end