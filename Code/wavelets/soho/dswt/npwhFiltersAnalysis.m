function ftabs = npwhFiltersAnalysis( tri)
%
% ftabs = npwhFiltersAnalysis( tri)  
%
% Analysis filters for normalized pseudo wavelets
%
% @return filter tabs matrix (4x4 matrix) with analysis filters
% @param  tri  domain for which the filter coefficients have to be computed
  
  % scaling basis function filter coefficients
  ftabs(1,1) = 0.5;
  ftabs(1,2) = 0.5;
  ftabs(1,3) = 0.5;
  ftabs(1,4) = 0.5;  
  
  % wavelet basis function filter coefficients 
  
  ftabs(2,1) =  0.5;
  ftabs(2,2) = -0.5;
  ftabs(2,3) = -0.5;
  ftabs(2,4) =  0.5;
  
  ftabs(3,1) =  0.5;
  ftabs(3,2) = -0.5;
  ftabs(3,3) =  0.5;
  ftabs(3,4) = -0.5;
  
  ftabs(4,1) =  0.5;
  ftabs(4,2) =  0.5;
  ftabs(4,3) = -0.5; 
  ftabs(4,4) = -0.5;
    
end
  
