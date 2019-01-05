function plotSTriList( stris)
% 
% plotSTriList( stris)
%
% Plot a linear slist of spherical triangles (no recursion)
%
% @param  stris  list of spherical triangles

  % plotUnitSphere;

  for( t = 1 : numel( stris))
    
    plotEdges2D( stris(t), 1.001, [0 0 0], [0 : 0.1 : 1], 1.5);
    
  end
  
end