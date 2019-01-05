function areas = getAreasLevel( tri, level)
%  
% areas = getAreasLevel( tri, level)
%
% Get the areas on level \a level of a wavelet tree
% 
% @return 
% @param  tri  root node of the wavelet tree
% @param  level  level on which to extract the areas

  areas = [];
  areas = getAreasLevelPrivate( tri, level, areas);
  
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function  areas = getAreasLevelPrivate( tri, level, areas)
  
  if( tri.level == level)
    
    areas( tri.index_level + 1) = tri.area;
    
  else
    
    % recursively traverse tree
    for( i = 1 : numel( tri.childs))
      areas = getAreasLevelPrivate( tri.childs(i), level, areas);
    end
    
  end
  
end