function ftabs = pwhFiltersSynthesis( tri)
%
% ftabs = pwhFiltersSynthesis( tri)  
%
% Compute reconstruction / synthesis filters for pseudo wavelets
% @return filter tabs matrix (4x4 matrix) with reconstruction filters
% @param  tri  domain for which the filter coefficients have to be computed
  
  % scaling basis function filter coefficients
  ftabs(1,1) = 0.25;
  ftabs(1,2) = 0.25;
  ftabs(1,3) = 0.25;
  ftabs(1,4) = 0.25;  
  
  % wavelet basis function filter coefficients 
  
  ftabs(2,1) =  0.25;
  ftabs(2,2) = -0.25;
  ftabs(2,3) = -0.25;
  ftabs(2,4) =  0.25;
  
  ftabs(3,1) =  0.25;
  ftabs(3,2) = -0.25;
  ftabs(3,3) =  0.25;
  ftabs(3,4) = -0.25;
  
  ftabs(4,1) =  0.25;
  ftabs(4,2) =  0.25;
  ftabs(4,3) = -0.25; 
  ftabs(4,4) = -0.25;  
  
end
  
