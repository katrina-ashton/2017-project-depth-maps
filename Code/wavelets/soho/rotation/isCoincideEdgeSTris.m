function is = isCoincideEdgeSTris( stris, ipoints, m_vert_ipoints)
%
% is = isCoincideEdgeSTris( stris, ipoints, m_vert_ipoints)
%
% Helper function for computeAreaOverlapSTris(): Check if the two 
% spherical triangles in \a stris only coincide in an edge, i.e. 
% the overlap area is 0
%
% @return 1 if the polygons only coincide in an edge, otherwise 0
% @param  polys  struct containing the two polygons
% @param  ipoints  list of intersection points between the edges of the two
%                  polygons
% @param  m_vert_ipoints  matrix describing which vertex coincides with an
%                         intersection point
  
  is = 0;  
  epsilon = 10^-14;

  % check if degenerated case where the quads only have one edge in common
  % but the area is disjoint
  
  sum_m_vert_ipoints_1 = sum( squeeze( m_vert_ipoints(1,:,:)), 1);
  sum_m_vert_ipoints_2 = sum( squeeze( m_vert_ipoints(2,:,:)), 1);
  
  if( all( or( sum_m_vert_ipoints_1, sum_m_vert_ipoints_2)))

    % more than two verts have to be colinear
    if( numel( ipoints) > 2)
      
      n = cross( ipoints(1).vert, ipoints(2).vert);
      n = n / norm( n);
      
      for( k = 3 : numel( ipoints))
      
        if( abs( dot( ipoints(k).vert, n)) > epsilon)
          return;
        end
      
      end
        
    end
      
    % the vertices have to lie on different sides
    
    n_base = cross( ipoints(1).vert, ipoints(2).vert);
    n_base = n_base / norm( n_base);
    
    s1 = findSideVertices( stris{1}, n_base);
    s2 = findSideVertices( stris{2}, n_base);    

    % sides have to be identical for all verts of one poly and the vertices
    % have to lie on different sides
    if( (1 == numel( unique( s1))) && (1 == numel( unique( s2))) )
      if( s1(1) ~= s2(1))
        
        is = 1;
        
      end      
    end
    
  end
  
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function s = findSideVertices( st, n_base)
%
% s = findSideVertices( st, n_base)
%  
% Find on which side of the edge whose normal is \a n_base the vertices of
% \a poly lie
  
  s = [];

  epsilon = 10^-14;

  for( i = 1 : 3)
    
    dp = dot( getVertex( st, i), n_base);
    if( abs( dp) > epsilon)
      s(end+1) = sign( dp);
    end    
    
  end
  
end