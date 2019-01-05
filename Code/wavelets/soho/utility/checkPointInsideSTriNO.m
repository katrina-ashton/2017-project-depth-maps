function is_inside = checkPointInsideSTriNO( tri, p)
%  
% checkPointInsideSTri( tri, p)
%
% Check if point \a p is inside \a tri when the orientation of the vertices
% in tri is not known
%
% @return  1 if \a p is in \a tri, otherwise 0
% @param  tri  spherical triangle 
% @param  p    point to test

  [n1 n2 n3] = getPlanes( tri);
  
  epsilon = 10^-14;
  s1 = sign( dot( n1, p) + epsilon);
  s2 = sign( dot( n2, p) + epsilon);
  s3 = sign( dot( n3, p) + epsilon);

  % construct plane in which all three points lie, p has to be on the same
  % side relative to the origin than these points
  verts = getVertsEC( tri);
  l1 = verts(:,2) - verts(:,1);
  l2 = verts(:,3) - verts(:,1);  
  n = cross( l1, l2);
  n = n / norm( n);
  s_v1 = sign( dot( n, verts(:,1)) + epsilon);
  condition( s_v1 == sign( dot( n, verts(:,2)) + epsilon));
  condition( s_v1 == sign( dot( n, verts(:,3)) + epsilon));  
  
  s_n = sign( dot( n, p) + epsilon);
  
  is_inside = 0;
  
  if(( s1 >= 0) && (s2 >= 0) && (s3 >= 0) && (s_n == s_v1))
    is_inside = 1;
  elseif(( s1 <= 0) && (s2 <= 0) && (s3 <= 0) && (s_n == s_v1))
    is_inside = 1;
  end  
  
end