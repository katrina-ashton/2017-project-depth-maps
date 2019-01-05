function stris = rotateForest( stris, R)
%
% stris = rotateForest( stris, R)
%
% Rotate the forest of wavelet trees \a stris by \a R
%
% @return  rotated wavelet tree
% @param stris  root nodes of forest of wavelet trees
% @param R      [3x3] rotation matrix

  for( t = 1 : numel( stris))

    % apply the rotation to the node
    stris(t) = rotate( stris(t), R);
    
    % recursively traverse tree
    childs = getChilds( stris(t));
    
    for( i = 1 : numel( childs))
      childs(i) = rotateForest( childs(i), R);
    end
    
    % store rotated childs
    stris(t) = setChilds( stris(t), childs);
    
  end  % end for all input tree

end
  
