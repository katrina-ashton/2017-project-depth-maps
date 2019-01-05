function  pos = getCentroidSTri( tri)
%
% pos = getCentroidSTri( tri)
%
% Get the centroid / center of a spherical triangle  
%
% @return  centroid of \a tri
% @param  tri  spherical triangle those centroid is seeked

  % get the vertices
  verts = getVertsEC( tri);
  
  % midpoint 1
  m1 = verts(:,1) + verts(:,2);
  m1 = m1 / norm(m1);
  
  m2 = verts(:,2) + verts(:,3);  
  m2 = m2 / norm(m2);  
  
  m3 = verts(:,3) + verts(:,1);  
  m3 = m3 / norm(m3);  

  % planes those intersection is the center point
  
  n1 = cross( m1, verts(:,3));
  n1 = n1 / norm( n1);
  
  n2 = cross( m2, verts(:,1));
  n2 = n2 / norm( n2);

  n3 = cross( m3, verts(:,2));
  n3 = n3 / norm( n3);

  % compute the intersection point on the unit sphere
  % note that the system is ill conditioned (there are infinit many
  % solutions) so that y = 1 is chosen and the resulting intersection point
  % is normalized so that it lies on the unit sphere

  % make sure that we do not divide by 0
  if( abs( n1(1)) > 10e-6)
  
    t1 = (n1 .* (-n2(1) / n1(1))) + n2;
    
    z = -t1(2) / t1(3);
    y = 1;
    x = (-n1(2) * y - n1(3) * z) / n1(1);
  
  else 
    
    t1 = (n1 .* (-n2(1) / n1(1))) + n2;

    z = 1;
    x = (n1(2) * n2(3) - n2(2) * n1(3)) / (n2(2) * n1(1) - n1(2) * n2(1));
    y = (-n2(1) * x - n2(3)) / n2(2);
  
  end
  
  assert( ~isnan( x));
  assert( ~isnan( y));
  assert( ~isnan( z));  
  
  pos = [x y z]';
  pos = pos / norm( pos);
  
  % sanity check, point has to be in triangle
  if( 1 ~= checkPointInsideSTri( tri, pos))
    % point on the wrong side of the sphere
    pos = pos * -1.0;
    if( 1 ~= checkPointInsideSTri( tri, pos))
      error( 'Center point not inside triangle.');
  end
  
end