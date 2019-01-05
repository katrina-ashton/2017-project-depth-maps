function plotCurvedLine( verts, offset_surface, col, line_width)
%
% plotCurvedLine( verts, offset_surface, col, line_width)
%
% Visualize edges as 2D arcs on the surface of the unit sphere
% @param  verts  [3 x n]  n points of the line
% @param  offset_surface  offset to avoid z fighting
% @param  col  color of arcs (rgb triple)

  % pre-process optional input arguments
  lw = 1;
  if( nargin > 3)
    lw = line_width;
  end
  line_width = lw;
  
  os = 1.0001;
  if( nargin > 1)
    os = offset_surface;
  end
  offset_surface = os;
  
  c = [1 0 0];
  if( nargin > 2)
    c = col;
  end
  col = c;

  % weights  
  w = 0 : 0.05 : 1;
  w = repmat( w, 3, 1);
  
  inv_w = 1 - w;

  % do for all three edges
  for edge = 1 : (size( verts, 2) - 1)

    v0 = repmat( verts(:,edge), 1, size( w, 2));
    v1 = repmat( verts(:,edge+1), 1, size( w, 2));        

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
    line( arc(1,:), arc(2,:), arc(3,:), 'Color', col, 'LineWidth', line_width);

  end

end