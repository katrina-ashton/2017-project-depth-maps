function plotForestCurved( forest, level, subdivision_level )
%
% plotForestCurved( forest, level, subdivision_level )
%
% Visualize the data associated with the partitions of \a forest at level
% \a level using spherical triangles. Only suitable for low sudivision
% levels.
%
% @param  root nodes of a forest of spherical triangles
% @param  level  level on which the data is defined which has to be
%                visualized (in the data fields of the corresponding nodes)
% @param  subdivision_level  number of subdivision steps for each spherical
%         triangle to generate a smooth appearance

  % for all trees
  for( t = 1 : numel( forest))
    
    if( getLevel( forest( t)) == level)
      
      col = abs(getData( forest(t))) /  255.0;
      col = max( zeros( size(col,1), 1), col);
      
      plotTriCurved( forest(t), 1.0001, subdivision_level, col);
      
    else
      
      childs = getChilds( forest(t));
      
      for( i = 1 : numel( childs))
        animForestCurved( childs(i), level, subdivision_level);
      end
      
    end
    
  end

end