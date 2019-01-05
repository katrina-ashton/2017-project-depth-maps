function coeffs = getCoeffsForest( stris, level)
%
% coeffs = getCoeffsForest( stris, level)
%
% Get the basis function coefficients of a forest of wavelet trees. The
% coefficients of one tree are stored contigously and one tree after the
% other
% 
% @return  complete set of basis function coefficients for the forest 
%          \a stris
% @param  stris  list of root nodes of a forest of wavelet trees
% @param  level  the coefficients up to (level - 1) are collected, i.e. on
%                the data which has been analysed has been defined on 
%                level \a level 

  coeffs = [];
  
  for( t = 1 : numel( stris))
    
    c = getCoeffsApprox( stris(t), level);
    coeffs = [coeffs  c];
    
  end

end