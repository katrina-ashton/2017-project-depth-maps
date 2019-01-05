function current = handleVertexIPointCoincideSTris( stris, ipoints, ...
                                                    m_vert_ipoints, ...
                                                    i_ipoint_coincide, current)
%
%
%
% 

  % find the edges on both stris where i_ipoint is the endpoint
  
  % intersection point coincides with vertex of both triangles
  if( 1 == all( ipoints(i_ipoint_coincide).is_vertex))
    
    e1 = findEdgeVertexStartpoint( stris{1}, ...
                                   ipoints(i_ipoint_coincide).is_vertex(1), ...
                                   current.orientation_stris(1));
    
    e2 = findEdgeVertexStartpoint( stris{2}, ...
                                   ipoints(i_ipoint_coincide).is_vertex(2), ...
                                   current.orientation_stris(2));
    
    
  elseif( ipoints(i_ipoint_coincide).is_vertex(1) > 0)

    e1 = findEdgeVertexStartpoint( stris{1}, ...
                                   ipoints(i_ipoint_coincide).is_vertex(1), ...
                                   current.orientation_stris(1));
    
    e2 = ipoints(i_ipoint_coincide).a1 + 1;
    
  elseif( ipoints(i_ipoint_coincide).is_vertex(2) > 0)
    
    e1 = ipoints(i_ipoint_coincide).a0 + 1;
    
    e2 = findEdgeVertexStartpoint( stris{2}, ...
                                   ipoints(i_ipoint_coincide).is_vertex(2), ...
                                   current.orientation_stris(2));

  else
    error( 'Unknown configuration.');
  end
    
  % perform look ahead 
  
  temp = current;
  
  temp.vert = ipoints( i_ipoint_coincide).vert;
  temp.index_ipoint = i_ipoint_coincide;  
  
  % look ahead for stris{1}
  temp.stri = 1;
  temp.edge = e1;
  v1 = getNextVertexEdgeSTri( stris, ipoints, m_vert_ipoints, temp, 0 );
  v1 = v1.vert;
  
  % look ahead for stris{2}  
  temp.stri = 2;
  temp.edge = e2;
  v2 = getNextVertexEdgeSTri( stris, ipoints, m_vert_ipoints, temp, 0 );
  v2 = v2.vert;                                      
    
  % compute normals of the planes in which the edges lie
  
  n_base = cross( temp.vert, current.vert);
  n_base = n_base / norm( n_base);
  
  n1 = cross( temp.vert, v1);
  n1 = n1 / norm( n1);
  
  n2 = cross( temp.vert, v2);
  n2 = n2 / norm( n2);                                         
                           
  d1 = dot( n_base, n1);
  d2 = dot( n_base, n2);  

  epsilon = 10^-14;
  d1( find( abs( d1) < epsilon)) = 0;
  d1( find( abs( d1) < epsilon)) = 0;  
  
  % resolve, choose edge which has the smaller angle with the plane of the
  % arc where the traversal is coming from
  
  % vertex is always the same, only edge and stri differ
  current.vert = ipoints(i_ipoint_coincide).vert;
  current.index_ipoint = i_ipoint_coincide;
  
  if( acos(d2) < acos(d1))
    current.stri = 2;
    current.edge = e2;
  else
    current.stri = 1;
    current.edge = e1;
  end
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function edge = findEdgeVertexStartpoint( st, i_vert, orientation)
%
% edge = findEdgeVertexStartpoint( st, i_vert, orientation)
%
% Find the edge on which \a i_vert is the starting point 
  
  index_startpoint = 2;
  if( -1 == orientation)
    index_startpoint = 1;
  end

  % get the two edges associated with the vertex
  edges = getEdgesVertex( st, i_vert);
  
  % get the vertices
  vs = getVerticesEdge( st, edges(1));
  
  if( vs(index_startpoint) == i_vert)
    edge = edges(1);
  else
    edge = edges(2);
  
    vs = getVerticesEdge( st, edges(2));
    condition( vs(index_startpoint) == i_vert);
  end
    
end