function plotData( stris, level) 
%
% plotData( stris, level) 
%
% Visualize data associated with spherical triangle
% @param  stris      root notes of forest of spherical triangles 
%                     (may be degenerated)
% @param  level      level on which the data is defined
% @note  It is assumed that the data is stored as data property field on the
% nodes of \a stris at level \a level

  for( i = 1 : numel( stris))

    if( level ==  stris(i).level)
    
      % draw the triangle
        
      % default offset to avoid aliasing due to piece-wise constant approximation 
      % of curves  
      offset_surface = 1.001;
      radius = 1.0;
      subdivision_level = 1;

      % edges
      % plotEdgesCurved( stris(i), offset_surface, radius, stris(i).color);

      % surface
      % swt = create_swtree( stris(i), subdivision_level);
      % plotFaceCurved( swt, subdivision_level, radius, stris(i).color);
      % plotFaceCurved( swt, subdivision_level, radius, stris(i).data / 255.0);  
      
      col = stris(i).data / 255.0;
      col = max( zeros( 3, 1), col);
      col = min( ones( 3, 1), col);
      plotFaceLinear( stris(i), col, col);
      
    elseif( level > stris(i).level)
      
      % recursively traverse the tree and process children
      for( k = 1 : numel( stris(i).childs))
        plotData( stris(i).childs(k), level);
      end
      
    else
      error( 'Invalid level specification');      
    end
  end

end