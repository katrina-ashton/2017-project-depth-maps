function plotPartitionEdgesLinear( forest, level, col)
%
% plotPartitionEdgesLinear( forest, level, col)
%
% Plot the edges of a partition (formed by a forest of trees) as straight
% lines 
  
  % set general parameters
  offset_surface = 1.001;

  % do for all input partitions
  for( p = 1 : numel( forest))
    
    % plot the edges of the current partition    
    plotEdgesLinear( forest(p), col);
    
    % recursively traverse the tree
    if( getLevel( forest(p)) < level)
    
      childs = getChilds( forest(p));
      
      plotPartitionEdgesLinear( childs, level, col);
      
    end
    
  end
  
end
