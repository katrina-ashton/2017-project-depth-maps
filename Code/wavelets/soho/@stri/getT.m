function [verts,radii,connect] = getT(stris, level)
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