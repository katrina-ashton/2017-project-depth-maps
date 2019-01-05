function plotEdges3D( tri, offset_surface, radius, col)
%
% plotEdges3D( tri, offset_surface, radius, col)
%
% @param  tri  spherical triangles those edges / great arcs forming the
%              sides have to be visualized
% @param  offset_surface  offset to avoid z fighting
% @param  radius  height of faces on surfaces
% @param  col  color of arcs (rgb triple)

  % weights  
  w = 0 : 0.05 : 1;
  w = repmat( w, 3, 1);
  
  % connectivity of vertices / definition of edges
  edges = [1 2; 1 3; 2 3];
 
  % edges of ground face
  face_edges = [];
  % cache
  inv_w = 1 - w;

  % do for all three edges
  for edge = 1 : 3

    v0 = repmat( tri.verts_ec(:,edges(edge,1)), 1, size( w, 2));
    v1 = repmat( tri.verts_ec(:,edges(edge,2)), 1, size( w, 2));        

    % interpolate between the vertices spanning the edge
    arc = inv_w .* v0 + w .* v1;
    arc_1 = [];
    arc_2 = [];    
    
    % normalize so that the points lie on the surface of the unit
    % sphere
    % add a small offset so that the lines are on top of the Matlab
    % sphere which is drawn first
    for i = 1 : size( arc, 2)
      arc_1(:,i) = (arc(:,i) / norm( arc(:,i))) * offset_surface;
      arc_2(:,i) = (arc(:,i) / norm( arc(:,i))) * radius;      
    end

    arc_final = [arc_1,  arc_2];
    face_edges = [face_edges, arc_2];

    len = size( arc_1, 2);
    T = [];
    for k = 1 : len - 1
      T(end+1, :) = [k     ,   k+1    , len+k   ];
      T(end+1, :) = [len+k ,  len+k+1 , k + 1   ];
    end
    trimesh( T, ...
             arc_final(1,:), ...
             arc_final(2,:), ...
             arc_final(3,:), ...
             'FaceColor', col, 'EdgeColor', 'none');
    alpha( 0.4);
    
  end

end