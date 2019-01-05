function [swt_approx , swt_analysed] = ...
  computeApproximationSignal( stris, im, level, basis, approx_ratio )
%                                                       
% [swt_approx , swt_analysed] = computeApproximationSignal( stris, im, ...
%                                                           level, basis, ...
%                                                           approx_ratio )
%                                                      
% Compute approximation of given signal \a im keeping \a approx_ration
% percent of the largest coefficients
%
% @return  swt_approx     forest of wavelet trees containing an
%                         approximation of \a im resampled onto the
%                         spherical wavelet basis \a basis
% @return  swt_approx     forest of wavelet trees containing \im resampled 
%                         onto the spherical wavelet basis \a basis
% @param  stris           root nodes of forest of spherical wavelet trees which 
%                         is employed to sample the LTS maps
% @param  basis           basis to use for the approximation
% @param  level           level of \a stris on which to resample the LTS
%                         maps
% @param  approx_ratio    [0,1] percentage of largest coefficients to keep
%                         for an approximation
% @param  base_path       path to image files
% @param  radius          radius of LTS maps, used to identify correct
%                         files

  % get necessary function handles for basis
  fhs = getFunctionHandlesBasis( basis);

  % reample the signal (10 samples per domain, do not show the sample locations)
  swt_sampled = sampleSphericalMap( stris, im, 10, level, 0);

  % perform forward wavelet transform on signal
  swt_analysed = dswtAnalyseFull( swt_sampled, level, ...
                                  fhs.filters_analysis, fhs.normalize);

  % get coefficients
  coeffs = getCoeffsForest( swt_analysed, level);
  num_coeffs_significant = max( 1, int16( nnz( coeffs) * approx_ratio));
                                
  % compute the threshold so that only the k largest coefficients are taken
  % into account in the next processing steps
  thresholds = getThresholdLargestK( swt_analysed, level, ...
                                     num_coeffs_significant,  ...
                                     fhs.approx_weight );

  % set coefficients below the threshold to 0
  swt_approx = approxSWT( swt_analysed, level, thresholds, fhs.approx_weight );
  
end