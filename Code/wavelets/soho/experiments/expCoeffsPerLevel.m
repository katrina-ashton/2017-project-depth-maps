function res = expCoeffsPerLevel( num_trees, levels, percent)
%
% res = expCoeffsPerLevel( num_trees, levels, percent)
%
% Compute non-zero coefficients to retain for the given approximation ratio
%
% @return [2,numel(levels)] levels and approximation ratios
% @param num_trees  number of trees over which the basis is defined
% @param levels  levels for which to determine coefficents
% @param percent  percentage of basis function coefficeints to retain for
%                 the approximation
  
  if( percent > 1)
    error( 'Percentage value has to be in [0,1]');
  end
  
  res = zeros( 2, numel( levels));
  
  for( l = 1 : numel( levels))
    
    coeffs_total = num_trees * 4^(levels(l));
    
    res(1,l) = levels(l);
    res(2,l) = coeffs_total * percent;
    
  end
  
end