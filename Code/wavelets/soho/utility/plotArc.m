function plotArc( verts, col, offset_surface, line_width)
%
% plotArc( verts, col, offset_surface)
%
% Visualize an arc specified by two points
%
% @param verts  [3x2] vertices of arc
% @param col  color of the arc (optional, default == blue)
% @param offset_surface  offset of arc w.r.t unit sphere 
%                        (optional, default == 1.001)

  % pre-process optional input arguments

  c = [0 0 1];
  if( nargin > 1)
    c = col;
  end
  col = c;
  
  os = 1.001;
  if( nargin > 2)
    os = offset_surface;
  end
  offset_surface = os;
  
  lw = 1;
  if( nargin > 3)
    lw = line_width;
  end
  line_width = lw;
  
  % weights  
  w = 0 : 0.05 : 1;
  w = repmat( w, 3, 1);
  inv_w = 1 - w;
  
  v0 = repmat( verts(:,1), 1, size( w, 2));
  v1 = repmat( verts(:,2), 1, size( w, 2));  
  
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
  line( arc(1,:), arc(2,:), arc(3,:), 'Color', col, 'LineWidth', lw);

end