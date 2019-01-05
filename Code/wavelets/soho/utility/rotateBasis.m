function stris = rotateBasis( stris, R) 
% Rotate the given discrete spherical Haar wavelet basis (note that this
% corresponds to rotating the domains of the basis functions)
% stris  root nodes of the wavelet tree
% R  rotation matrix

  % do for all trees
  for i = 1 : numel(stris)
  
    % rotate the spherical triangle 
    stris(i) = rotate( stris(i), R);
    
    % recursively rotate the children
    if( numel( getChilds( stris(i))) > 0)
      stris(i) = setChilds( stris(i), rotateBasis( getChilds( stris(i)), R));
    end
    
  end
  
end