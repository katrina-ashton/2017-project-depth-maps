function is_inside = checkPointInsideSTri( tri, p)
%  
% checkPointInsideSTri( tri, p)
%
% Check if point \a p is inside \a tri
%
% @return  1 if \a p is in \a tri, otherwise 0
% @param  tri  spherical triangle 
% @param  p    3D point on the sphere to test

  [n1, n2, n3] = getPlanes( tri);
  
  epsilon = 10^-14;
  s1 = sign( dot( n1, p) + epsilon);
  s2 = sign( dot( n2, p) + epsilon);
  s3 = sign( dot( n3, p) + epsilon);

  is_inside = 0;
  
  obit = getOrientationBit( tri);
  
  if( 1 == obit)
    if(( s1 >= 0) && (s2 >= 0) && (s3 >= 0))
      is_inside = 1;
    end
  elseif( -1 == obit)
    if(( s1 <= 0) && (s2 <= 0) && (s3 <= 0))
      is_inside = 1;
    end  
  else
    error( 'Unknown configuration.');
  end
  
end