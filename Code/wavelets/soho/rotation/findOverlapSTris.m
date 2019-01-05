function verts_overlap = findOverlapSTris( t0, t1, inside_t0, inside_t1, ...
                                           ipoints)
%
% vverts_overlap = findOverlapSTris( t0, t1, inside_t0, inside_t1, ipoints)
%
% Find the overlap between the spherical triangles t0 and t1
%
% @param  t0  spherical triangle
% @param  t1  spherical triangle
% @param  inside_t0  list which denotes which vertices from t1 are inside t0
% @param  inside_t1  list which denotes which vertices from t0 are inside t1
% @param  ipoints  list of intersection points between the edges of t0 and t1

  verts_overlap = [];

  % container for more convenient handling
  stris = {t0 , t1};

  m_ipoints_edge = computeIPointEdgeMatrix( ipoints);
  [ipoints , m_vert_ipoints] = computeVertexIPointMatrix( stris, ipoints );

  % check if the two polygons only coincide in one edge
  if( 1 == isCoincideEdgeSTris( stris, ipoints, m_vert_ipoints));
    return;
  end
  
  current.orientation_stris = findOrientationSTris( stris);

  current = findFirstPointSTris( stris, inside_t0, inside_t1, ipoints, ...
                                 m_ipoints_edge, m_vert_ipoints, ...
                                 current );
  verts_overlap = current.vert;
  
  
  while(    ( size( verts_overlap, 2) < 2) ...
         || (1 ~= all( verts_overlap(:,1) == verts_overlap(:,end))) )
       
    % check if there are intersection points on the current edge
    i_ipoint = ...
      find( 1 == squeeze( m_ipoints_edge(current.stri, : , current.edge)));
    i_ipoint = removeCurrentFromIPointList( current, i_ipoint);
    condition( numel( i_ipoint) <= 1);
    
    if( numel( i_ipoint) > 0)
      
      % check if intersection point coincides with vertex
      if( 1 == any( ipoints(i_ipoint).is_vertex))
        
         current = handleVertexIPointCoincideSTris( stris, ipoints, ...
                                                    m_vert_ipoints, ...
                                                    i_ipoint, current );
        
      else  % intersection point does not coincide with vertex
        
        % check that intersection point does not lie behind current
        % intersection point
        v = getNextVertexEdgeSTri( stris, ipoints, m_vert_ipoints, current );
        
        % compute distances
        d1 = acos( dot( v.vert, current.vert));
        d2 = acos( dot( v.vert, ipoints( i_ipoint).vert));
        
        if( d1 > d2)
          
          % set vertex
          current.vert = ipoints( i_ipoint).vert;          
         
          % intersection point implies that active stri is switched
          current = switchSTriCurrent( current);

          % set edge
          current = setCurrentEdge( current, ipoints( i_ipoint));

          % remember index of ipoint
          current.index_ipoint = i_ipoint;
          current.index_vertex = -1;
          
        else  % intersection point lies behind current point on the edge
          
          current = v;
          
        end
        
      end
      
    else   % no intersection point on current edge
    
      current = getNextVertexEdgeSTri( stris, ipoints, m_vert_ipoints, ...
                                       current ); 
      
    end
       
    % store next point
    verts_overlap(:,end+1) = current.vert;
    
    if(1 == all( verts_overlap(:,1) == verts_overlap(:,end)))
      break;
    end
         
  end
  
  
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function orientation = findOrientationSTris( stris)
%
%
%
% Find orientation of quads
 
  n1 = cross( getVertex( stris{1}, 1), getVertex( stris{1}, 2));
  n1 = n1 / norm( n1);
  dp1 = dot( n1, getVertex( stris{1}, 3));
  s_dp1 = sign( dp1);
  condition( 0 ~= s_dp1);
  
  n2 = cross( getVertex( stris{2}, 1), getVertex( stris{2}, 2));
  n2 = n2 / norm( n2);
  dp2 = dot( n2, getVertex( stris{2}, 3));
  s_dp2 = sign( dp2);
  condition( 0 ~= s_dp2);
  
  orientation = ones(1,2);
  if( s_dp1 ~= s_dp2)
    orientation(2) = -1;
  end
  
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function  m_ipoints_edge = computeIPointEdgeMatrix( ipoints)
%
%
%
% 

  m_ipoints_edge = zeros( 2, numel( ipoints), 3);

  for( k = 1 : numel( ipoints))
    
    m_ipoints_edge(1 , k , ipoints(k).a0 + 1) = 1.0;
    m_ipoints_edge(2 , k , ipoints(k).a1 + 1) = 1.0;    
    
  end
  
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [ipoints , m_vert_ipoints] = computeVertexIPointMatrix( stris, ipoints)
%
% ipoints , m_vert_ipoints] = computeVertexIPointMatrix( stris, ipoints)
%
%

  m_vert_ipoints = zeros( 2, 3, numel( ipoints));

  % do for all intersection points
  for( k = 1 : numel( ipoints))

    ipoints(k).is_vertex = zeros(1,2);
    
    % do for all vertices of the two triangles
    for( i = 1 : 3)     
      
      if( 1 == equalPoints( getVertex( stris{1}, i), ipoints(k).vert))

        m_vert_ipoints( 1, i, k) = 1.0;

        % stris have to be non-degenerated, i.e. no vertices coincide        
        condition( 0 == ipoints(k).is_vertex(1));
        ipoints(k).is_vertex(1) = i;
        
      end
     
      if( 1 == equalPoints( getVertex( stris{2}, i), ipoints(k).vert))
        
        m_vert_ipoints( 2, i, k) = 1.0;
        
        % stris have to be non-degenerated, i.e. no vertices coincide
        condition( 0 == ipoints(k).is_vertex(2));
        ipoints(k).is_vertex(2) = i;        

      end
      
    end
  end
  
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function  current = switchSTriCurrent( current)
%
%
%
%
 
  if( 1 == current.stri)
    current.stri = 2;
  elseif( 2 == current.stri)
    current.stri = 1;
  else
    error( 'Unknown configuration.');
  end

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function current = setCurrentEdge( current, ipoint)
%
%
%
%

  if( 1 == current.stri)
    current.edge = ipoint.a0 + 1;
  else
    current.edge = ipoint.a1 + 1;
  end
  
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function i_ipoint = removeCurrentFromIPointList( current, i_ipoint)
%
%
%
%
  
 i_ipoint = setdiff( i_ipoint, current.index_ipoint);  
 condition( numel( i_ipoint) <= 1);
 
end