function plot3D( stris, levels, draw_lines) 
% Plot the spherical triangle
% stris      spherical triangles to plot
% levels  number of child levels to plot with st
% draw_lines {0,1} switch if lines connecting the vertices should be drawn
%                  or not

  % check if lines should be drawn  
  dl = 1;
  if( nargin >= 3)
    dl = draw_lines;
  end
  draw_lines = dl;

  % begin plotting

  % plot the unit sphere
  [X,Y,Z] = sphere;
  mesh( X, Y, Z, 'EdgeAlpha', 1, ...
                 'EdgeColor', [0.75 0.75 0.75], ...
                 'EdgeLighting', 'none');
%                , ...
%                  'FaceColor', 'none');
  
  axis equal;
  axis off;
  % grid on;
  hold on;
    
  for k = 1 : numel(stris)
    
%     % plot the vertices
%     plot3( stris(k).verts_ec(1,:), stris(k).verts_ec(2,:), stris(k).verts_ec(3,:), ...
%            'rx', ...
%            'MarkerSize', 10, ...
%            'LineWidth', 2);

    % plot lines
    if(( 1 == draw_lines) && (0 == levels))
      % first vertex has to be duplicated to draw full triangle
      line( [stris(k).verts_ec(1,:) stris(k).verts_ec(1,1)], ...
            [stris(k).verts_ec(2,:) stris(k).verts_ec(2,1)], ...
            [stris(k).verts_ec(3,:) stris(k).verts_ec(3,1)], ...
            'Color', [1 0 0]);
    elseif(( 2 == draw_lines) && (0 == levels))
      % plot triangle with filled face, where the color depends on the scaling
      % coefficient value
      T = delaunay( stris(k).verts_ec(1,:), stris(k).verts_ec(2,:));
      c = [1 0 0];
      trimesh( T, ...
               stris(k).verts_ec(1,:), ...
               stris(k).verts_ec(2,:), ...
               stris(k).verts_ec(3,:), ...
               'FaceColor', c, 'EdgeColor', 'none');
             
    elseif(( 3 == draw_lines) && ( 0 == levels))
      
      w = 0 : 0.05 : 1;
      w = repmat( w, 3, 1);
      inv_w = 1 - w;
      
      % composition of edges
      edges = [1 2; 1 3; 2 3];
      
      % do for all three edges
      for edge = 1 : 3

        v0 = repmat( stris(k).verts_ec(:,edges(edge,1)), 1, size( w, 2));
        v1 = repmat( stris(k).verts_ec(:,edges(edge,2)), 1, size( w, 2));        
        
        % interpolate between the vertices spanning the edge
        arc = inv_w .* v0 + w .* v1;
        
        % normalize so that the points lie on the surface of the unit
        % sphere
        % add a small offset so that the lines are on top of the Matlab
        % sphere which is drawn first
        for i = 1 : size( arc, 2)
          arc(:,i) = (arc(:,i) / norm( arc(:,i))) * 1.001;
        end
        
        % draw the arc
        line( arc(1,:), arc(2,:), arc(3,:), 'Color', [0 0 1]);

      end
      
    end

    % traverse children if requested
    if( nargin > 1)
      if(( levels > 0) && ( 4 == numel( stris(k).childs)))

        for i = 1 : 4

          plot3D( stris(k).childs(i), levels - 1, draw_lines);
        end
        
      end
    end

  end % for all spherical triangels
    
end