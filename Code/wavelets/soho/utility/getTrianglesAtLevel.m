function stris = getTrianglesAtLevel( forest, level)
%
% stris = getTrianglesAtLevel( forest, level)
%
% Collect all triangles at level \a level in the forest of triangle trees
%
% @return  cell array of all spherical triangles from \a forest on level \a
%          level
% @param  forest  forest of tress of spherical triangles

  stris = [];

  % do for all trees in the forest
  for( t = 1 : numel( forest))
    
    temp = [];
    temp = getTrianglesAtLevelInTree( forest(t), level, temp);
    
    stris = [stris  temp];
    
  end

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function stris = getTrianglesAtLevelInTree( tri, level, stris)

  if( getLevel( tri) == level)

    stris = [stris  tri];
    
  else
    
    % recursively traverse the tree
    childs = getChilds( tri);
    
    for( i = 1 : numel( childs))
      
      stris = getTrianglesAtLevelInTree( childs(i), level, stris);
      
    end
    
  end

end