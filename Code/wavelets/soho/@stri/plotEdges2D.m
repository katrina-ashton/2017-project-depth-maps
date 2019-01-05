function plotEdges2D( tri, offset_surface, col, weights, line_width)
%
% plotEdges2D( tri, offset_surface, col, weights, line_width)
%
% Visualize edges as 2D arcs on the surface of the sphere
% @param  tri  spherical triangles those edges / great arcs forming the
%              sides have to be visualized
% @param  offset_surface  offset to avoid z fighting
% @param  col  color of arcs (rgb triple)
% @param  weights  weight vertex to employ to interpolate the edges between
%                  the vertices on the surface of the sphere

  wt = 0 : (1/3) : 1;
  if( nargin > 3)
    wt = weights;
  end
  w = wt;

  lw = 1.0;
  if( nargin > 4)
    lw = line_width;
  end
  line_width = lw;
  
  % weights  
  w = repmat( w, 3, 1);
  
  % connectivity of vertices / definition of edges
  edges = [1 2; 1 3; 2 3];
  
  inv_w = 1 - w;

  % do for all three edges
  for edge = 1 : 3

    v0 = repmat( tri.verts_ec(:,edges(edge,1)), 1, size( w, 2));
    v1 = repmat( tri.verts_ec(:,edges(edge,2)), 1, size( w, 2));        

    % interpolate between the vertices spanning the edge
    arc = inv_w .* v0 + w .* v1;

    % normalize so that the points lie on the surface of the unit
    % sphere
    % add a small offset so that the lines are on top of the Matlab
    % sphere which is drawn first
    for i = 1 : size( arc, 2)
      arc(:,i) = (arc(:,i) / norm( arc(:,i))) * offset_surface;
    end

    % draw the arc
    line( arc(1,:), arc(2,:), arc(3,:), ...
          'Color', col, ...
          'LineWidth', line_width );

  end

end