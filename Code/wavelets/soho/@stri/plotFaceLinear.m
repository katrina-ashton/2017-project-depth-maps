function plotFaceLinear( tri, col_face, col_edge)
% Plot faces of spherical triangle as flat triangle approximation
% @param  tri  spherical triangle to visualize
% @param col_face  face color
% @param col_edge  edge color

  c = [1 1 1];
  if( nargin > 1)
    c = col_face;
  end
  col_face = c;
  
  c = [1 1 1];
  if( nargin > 2)
    c = col_edge;
  end
  col_edge = c;
  

  T = delaunay( tri.verts_ec(1,:), tri.verts_ec(2,:));
  c = [1 0 0];
  trimesh( T, ...
           tri.verts_ec(1,:), ...
           tri.verts_ec(2,:), ...
           tri.verts_ec(3,:), ...
           'FaceColor', col_face, 'EdgeColor', col_edge);

end