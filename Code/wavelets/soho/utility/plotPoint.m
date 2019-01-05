function plotPoint( vert)
%
% plotPoint( vert)
%
% Visualize the vertex \a vert as point
%
% @param  vert  position of the point to visualize

  if( size( vert, 1) == 3)
    vert = vert';
  end

  vert = repmat( vert, 2, 1);
  vert(:,2) = vert(:,2) + 0.05;
  
  plot3( vert(:,1) , vert(:,2) , vert(:,3), 'Color', [1 0 0], 'MarkerSize', 20);
  
end