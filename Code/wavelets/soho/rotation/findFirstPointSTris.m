function current = findFirstPointSTris( stris, inside_t0, inside_t1, ...
                                        ipoints, ...
                                        m_ipoints_edge, m_vert_ipoints, ...
                                        current )
%
%
%
% 
  
  % iterate through all intersection points if there is an "ingoing" edge
  % going into t1, the intersection point may not coincide with a vertex
  % (complicated case, handled later if necessary)
  
  for( k = 1 : numel( ipoints))
    
    % skip intersection points
    if( ipoints(k).is_vertex(1) > 0)
      continue;
    end
    
    % find the vertices which form the edge on which the intersection
    % point lies
    verts = getVerticesEdge( stris{1}, ipoints(k).a0 + 1);
    
    % the first stri has always the "correct" orientation
    % the first vertex of the edge is the endpoint
    if( 1 == inside_t1(verts(1)))
      
      current.vert = ipoints(k).vert;
      current.edge = ipoints(k).a0 + 1;
      current.index_ipoint = k;
      current.stri = 1;
      
      return;
      
    end
    
  end
  
  % no intersection point found where the end point lies in t1
  
  % try to find a pair of intersection points which lie on the same edge 
  sum_m_ipoints_edge = sum( squeeze( m_ipoints_edge(1,:,:)), 1);
  i_edge_pair = find( 2 == sum_m_ipoints_edge);
  
  if( numel( i_edge_pair) > 0)
    
    % one pair sufficient
    i_edge_pair = i_edge_pair(1);
    
    % find the corresponding intersection points
    i_ipoints = find( squeeze( m_ipoints_edge(1,:,i_edge_pair)));
    
    % compute distance from startpoint of edge / great arc
    
    i_verts = getVerticesEdge( stris{1}, i_edge_pair);
    
    vert = getVertex( stris{1}, i_verts(2));
    
    d1 = acos( dot( vert, ipoints(i_ipoints(1)).vert));
    d2 = acos( dot( vert, ipoints(i_ipoints(2)).vert));    
    
    if( d1 < d2)
      
      current.vert = ipoints(i_ipoints(1)).vert;
      current.index_ipoint = i_ipoints(1);
      
    else
      
      current.vert = ipoints(i_ipoints(2)).vert;
      current.index_ipoint = i_ipoints(2); 
      
    end
    
    current.edge = i_edge_pair;
    current.stri = 1;
    
  else
  
    % no pair found
    % again visit the intersection points which coincide with vertices
    i_ipoint = -1;
    for( k = 1 : numel( ipoints))
      if( ipoints(k).is_vertex(1) > 0)
        i_ipoint = k;
        break;
      end      
    end
    condition( i_ipoint > 0);
    
    % get the edges associated with the vertex
    edges = getEdgesVertex( stris{1}, ipoints( i_ipoint).a0 + 1 );
    
    % index of the vertex associated with the intersection point
    i_vert = find( squeeze( m_vert_ipoints(1,:,i_ipoint)));
    condition( numel( i_vert) == 1);
    
    % the vertex is the endpoint of one of the edges
    i_vs = getVerticesEdge( stris{1}, edges(1));
    if( i_vs(1) == i_vert)
      current.edge = edges(1);      
    else
      current.edge = edges(2);
      
      % sanity check
      i_vs = getVerticesEdge( stris{1}, edges(2));
      condition( i_vs(1) == i_vert);
    end
    
    % virtually come from start point of edge
    i_vs = getVerticesEdge( stris{1}, current.edge);
    current.vert = getVertex( stris{1}, i_vs(2));
    
    current.stri = 1;
    current.index_ipoint = -1;
    
    current = handleVertexIPointCoincideSTris( stris, ipoints, ...
                                               m_vert_ipoints, ...
                                               i_ipoint, current );
    
  end
    
end