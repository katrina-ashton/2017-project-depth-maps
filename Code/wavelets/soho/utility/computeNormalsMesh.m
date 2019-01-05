function m = computeNormalsMesh( m)
%
% m = computeNormalMesh( m)
%
% Compute normals for all mesh triangles
% 
% @return m  mesh with data field m.N for the normals
% @param m  mesh struct as returned from loadObj

  % create new field
  m.N = zeros( 3, size( m.F, 2));
  
  % do for all triangles
  for( t = 1 : size( m.F, 2))
    
    % compute sides of triangle
    s1 = m.V( 1:3, m.F(2,t)) - m.V( 1:3, m.F(1,t));
    s2 = m.V( 1:3, m.F(3,t)) - m.V( 1:3, m.F(1,t));    
    
    n = cross( s1, s2);
    
    m.N(:,t) = n / norm( n);
    
  end  % end for all triangles

end