function plotEdgesCurved( tri, offset_surface, radius, col)
%
% plotEdgesCurved( tri, offset_surface, radius, col)
%
% Plot edges of spherical triangle as curved approximation
% @param  tri  spherical triangle to visualize  
% @param  offset_surface  [0.2]  initial offset w.r.t to sphere surface to avoid 
%                         artifacts arising from the piece-wise linear 
%                         approximation 
% @param  radius    [0,2]  radius at which 3D edges are plot (1.0 implies that 
%                   lines are drawn on the surface of the unit sphere)

  he = 0;
  if( nargin > 2)
    he = radius;
  end
  radius = he;
   
  if( ( abs( radius) > 2)  || ( abs( radius) < 0))
    error( 'Value for height of edges out of range.');
  end
  
  c = [0 0 1]';
  if( nargin > 3)
    c = col;
    if( numel( c) == 1)
      c = repmat( c, 3, 1);
    elseif( numel( c) ~= 3)
      error( 'Invalid color specified.');
    end
  end
  col = c;

  % visualize
  if( 1.0 == radius) 
    plotEdges2D( tri, offset_surface, col);
  else
    plotEdges3D( tri, offset_surface, radius, col);
  end
  
end
