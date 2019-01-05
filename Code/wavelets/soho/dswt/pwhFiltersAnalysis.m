function ftabs = pwhFiltersAnalysis( tri)
%
% ftabs = pwhFiltersAnalysis( tri)  
%
% Compute analysis filters for pseudo wavelets
% @return filter tabs matrix (4x4 matrix) with analysis filters
% @param  tri  domain for which the filter coefficients have to be computed
  
  % scaling basis function filter coefficients
  ftabs(1,1) = 1;
  ftabs(1,2) = 1;
  ftabs(1,3) = 1;
  ftabs(1,4) = 1;  
  
  % wavelet basis function filter coefficients 
  
  ftabs(2,1) =  1;
  ftabs(2,2) = -1;
  ftabs(2,3) = -1;
  ftabs(2,4) =  1;
  
  ftabs(3,1) =  1;
  ftabs(3,2) = -1;
  ftabs(3,3) =  1;
  ftabs(3,4) = -1;
  
  ftabs(4,1) =  1;
  ftabs(4,2) =  1;
  ftabs(4,3) = -1; 
  ftabs(4,4) = -1;
    
end
  
