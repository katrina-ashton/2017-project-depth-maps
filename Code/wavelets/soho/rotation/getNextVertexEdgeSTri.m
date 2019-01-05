function current = getNextVertexEdgeSTri( stris, ipoints, m_vert_ipoints, ...
                                          current, recursive )
%
%
%
%
  
  % pre-process optional input arguments
  r = 1;
  if( nargin > 4)
    r = recursive;
  end
  recursive = r;
  
  % get vertices corresponding to current edge
  i_vs = getVerticesEdge( stris{ current.stri}, current.edge);
  
  if( 1 == current.orientation_stris(current.stri))
    i_vert = i_vs(1);
  elseif( -1 == current.orientation_stris(current.stri))
    i_vert = i_vs(2);       
  else
    error( 'Unknown configuration.');
  end
  
  % check if vertex coincides with intersection point
  i_ipoints = find( 1 == squeeze( m_vert_ipoints( current.stri, i_vert, :)));
  condition( numel( i_ipoints) <= 1);
  
  if(( 1 == numel( i_ipoints)) && (1 == recursive))
  
    current = handleVertexIPointCoincideSTris( stris, ipoints, ...
                                               m_vert_ipoints, ...
                                               i_ipoints(1), current);
  else
    
    % vertex does not coincide with intersection point
    
    current.vert = getVertex( stris{current.stri}, i_vert);
    current.edge = current.edge + current.orientation_stris(current.stri); 
    
    current.index_ipoint = -1;
    current.index_vertex = i_vert;
    current.is_vertex(current.stri) = 1;
    
  end
  
  % wrap around
  
  if( current.edge > 3)
    current.edge = 1;
  end
  
  if( current.edge < 1)
    current.edge = 3;
  end
  
                                
end