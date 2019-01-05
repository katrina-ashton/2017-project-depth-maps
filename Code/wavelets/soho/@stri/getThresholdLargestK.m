function threshold = getThresholdLargestK( forest, level, k, fh_approx)
%
% threshold = getThresholdLargestK( forest, level, k, fh_approx)
%
% Compute the threshold for the K largest coefficients
%
% @return  threshold(s), one row per data channel
% @param  stris  root nodes of forest of wavelet trees
% @param  level  level on which the data was defined
% @param  k  number of coefficients to take into account 
% @param  fh_approx  handle to function providing the full contribution of
%                    a wavelet basis function coefficient to the signal
%                    (and therefore also to the error)
% @note data channels are treated independently

  fa = @getWaveletCoeffs;
  if( nargin > 2)
    fa = fh_approx;
  end
  fh_approx = fa;

  % extract the coefficients from all trees 
  coeffs = [];
  
  for( t = 1 : numel( forest))
    
    c  = getCoeffsApprox( forest(t), level, fh_approx);
    coeffs = [coeffs  abs(c)];    
 
  end
  
  
  % sort coefficients
  coeffs = sort( coeffs, 2, 'descend' );

  % determine threshold (midpoint between k and k+1)
  threshold = (coeffs(:,k) + coeffs(:,k+1)) / 2;
  
end