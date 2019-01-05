function  plotTriangle( verts, col, line_width )
%
% plotTriangle( verts, col, line_width )
%
% Plot a planar triangle in 3D
%
% @param  verts  vertices of the triangle
% @param  col    color of the outline of the triangle
% @param  line_width  width of the outline of the triangle

  % pre-process optional input arguments
  c = [1 1 0];
  if( nargin > 1)
    c = col;    
  end
  col = c;
  
  lw = 1;
  if( nargin > 2)
    lw = line_width;
  end
  line_width = lw;
  
  % repeat first vertex
  verts = verts(:,[1 2 3 1]);
  
  plot3( verts(1,:), verts(2,:), verts(3,:), ...
         'Color', col, 'LineWidth', line_width);
  
end