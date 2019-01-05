function plotEdgesLinear( tri, col)
%
% plotEdgesLinear( tri)
%
% Plot edges of spherical triangle as straight lines
%
% @param  tri  spherical triangle to visualize  
% @param  col  color of the edge (optional, default = blue)
  
  % pre-process optional input arguments

  c = [0 0 1];
  if( nargin > 1)
    c = col;    
  end
  col = c;

  % first vertex has to be duplicated to draw full triangle
  line( [tri.verts_ec(1,:) tri.verts_ec(1,1)], ...
        [tri.verts_ec(2,:) tri.verts_ec(2,1)], ...
        [tri.verts_ec(3,:) tri.verts_ec(3,1)], ...
        'Color', col);

end