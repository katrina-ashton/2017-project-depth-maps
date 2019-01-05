function plotPartitionEdgesCurved( forest, level, col)
%
% plotPartitionEdgesCurved( forest, level, col)
%
% Plot the edges of a partition (formed by a forest of trees) as curved
% approximations on the surface of the sphere
  
  % set general parameters
  offset_surface = 1.001;

  % do for all input partitions
  for( p = 1 : numel( forest))
    
    % plot the edges of the current partition    
    plotEdges2D( forest(p), offset_surface, col);
    
    % recursively traverse the tree
    if( getLevel( forest(p)) < level)
    
      childs = getChilds( forest(p));
      
      plotPartitionEdgesCurved( childs, level, col);
      
    end
    
  end
  
end
