function plotDataFastF( stris, level, file_name, plot_unitsphere) 
%
% plotData( stris, level, file_name, plot_unitsphere) 
%
% Visualize data associated with spherical triangles.
% @param  stris      root nodes of forest of spherical triangles 
%                     (may be degenerated)
% @param  level      level on which the data is defined
% @param  file_name  if specified then the data is stored and not plotted
% @param  plot_unitsphere  if 1 a unitsphere is plotted explicitly
% @note  It is assumed that the data is stored as data property field on the
% nodes of \a stris at level \a level

  % pre-process optional input arguments

  fn = '';
  if( nargin > 2)
    fn = file_name;
  end
  file_name = fn;
  
  pus = 0;
%   if( nargin > 3)
%     pus = plot_unitsphere;
%   end
%   plot_unitsphere = pus;
  
  % collect all vertices
  verts = [];
  radii  = [];
  T = [];
  
  for( i = 1 : numel( stris))
   
    v = []; r = [];  connect = [];
    [v , r, connect] = collectVertsColors( stris(i), level, v, r, connect);
                                         
    T = [T ; connect + size(verts,2)];
    verts = [verts v];
    radii = [radii r];
  end

%   size(verts)
%   size(radii)
  
  if( 0 == numel( file_name))
  
%     if( plot_unitsphere > 0)
%       plotUnitSphere();
%     else
      %figure;  
%     end
    
    r = abs(radii);	
    
    x = verts(1,:); y=verts(2,:); z=verts(3,:);
    [phi, theta, ~] = cart2sph(x,y,z);

    theta = abs(theta-pi/2);
    phi = pi + phi;
    
    x = r.*sin(theta).*cos(phi); 
    y = r.*sin(theta).*sin(phi);
    z = r.*cos(theta);
    
    %scatter3(x,y,z, '*', 'filled', 'MarkerFaceColor', 'k', 'MarkerEdgeColor', 'k')
    trisurf(T,x,y,z)
%   else
%     
%     addpath mcgl/core/ mcgl/impexp/ mcgl;
%     M = indexedfaceset( verts', T, 'vertexcolor', radii');
%     
%     savevrml( M, file_name);
% 
   end
           
end
         
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [verts , radii, connect] = collectVertsColors( tri, level, ...
                                                    verts, radii, connect)

  if( tri.level == level)
     
%     if( numel( tri.data) ~= 0)
% 
%       % compute color
%       % Use for face recognition: 
%       % col = abs(tri.data) / 3; % / 255.0;
%       col = tri.data;
%       
%     else
%       
%       error( 'Data field not defined.');
%       
%     end
      
    % index with offset
    index = (3 *  tri.index_level) + 1;
    
    % store vertices
    verts( : , index : index + 2) = tri.verts_ec;
    % use this variant for maya export (X axis has to be flipped)
    % verts( : , index : index + 2) = tri.verts_ec .* [-1 -1 -1; 1 1 1; 1 1 1];    
    
    % store colors (for grayscale image duplicate the data channel)
%     if( 3 == numel( col))
%       radii( : , index : index + 2) = repmat( col, 1, 3);
%     else
%       radii( : , index : index + 2) = repmat( col, 3, 3);
%     end
    radii = [radii,tri.data',tri.data',tri.data']; %somehow need this * 3
    %store connectivity
    connect( tri.index_level + 1, :) = [index + 2 , index + 1 , index];
    
  else

    % recursively traverse the tree
    for( j = 1 : numel( tri.childs))
      [verts , radii, connect] = collectVertsColors(tri.childs(j), level, ...
                                                     verts, radii, connect);
    end

  end

end
