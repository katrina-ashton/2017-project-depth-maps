function plotFaceCurved( tri, subdiv_steps, offset_vert_pos, col) 
% Plot face of a spherical triangle as curved approximation
% @param  tri  spherical triangle to visualize
% @param  subdiv_steps  number of subsidivision steps for curved approximation
% @param  offset_vert_pos  offset of vertex positions from sphere surface
% @param  color of spherical triangle

  % more subdivision steps?
  if( subdiv_steps > 0)
    
    for i = 1 : numel( tri.childs)
      plotFaceCurved( tri.childs(i), subdiv_steps - 1, offset_vert_pos, col);
    end       
    
  else
  
    % plot triangle with filled face
    T = delaunay( tri.verts_ec(1,:), tri.verts_ec(2,:));
    trimesh( T, ...
             tri.verts_ec(1,:) * offset_vert_pos, ...
             tri.verts_ec(2,:) * offset_vert_pos, ...
             tri.verts_ec(3,:) * offset_vert_pos, ...
             'FaceColor', col, 'EdgeColor', 'none');
    alpha( 0.6);
           
  end
  
end