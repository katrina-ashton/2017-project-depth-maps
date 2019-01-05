function plotVertices( tri)
% Plot vertices of spherical triangle
% @param  tri  spherical triangle to visualize

  plot3( tri.verts_ec(1,:), tri.verts_ec(2,:), tri.verts_ec(3,:), ...
         'rx', ...
         'MarkerSize', 10, ...
         'LineWidth', 2);
       
end
