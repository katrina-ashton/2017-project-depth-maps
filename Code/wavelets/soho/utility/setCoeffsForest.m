function  stris = setCoeffsForest( stris, level, coeffs)
%
% stris = setCoeffsForest( stris, level, coeffs)
%
% Set basis function coefficients for a forest of wavelet trees
% 
% @return  list of root nodes of a forest of wavelet trees where the
%          basis function coefficients from \a coeffs have been stored in the
%          appropriate nodes of the wavelet trees
% @param   stris  list of root nodes of a forest of wavelet trees
% @param   level  the basis function coefficients correspond to all basis fcts.
%                 from level 0 up to level (\a level - 1), i.e. the data
%                 represented by the coefficients has been defined on level \a
%                 level
% @param   coeffs  vector of basis function coefficients

  % number of coefficients per tree
  num_coeffs_tree = 4^level;
  
  % do for all trees
  for( t = 1 : numel( stris))
    
    r = ((t-1) * num_coeffs_tree + 1) : (t * num_coeffs_tree);
    stris(t) = setCoeffs( stris(t), level, coeffs(:,r));    
    
  end
  
end