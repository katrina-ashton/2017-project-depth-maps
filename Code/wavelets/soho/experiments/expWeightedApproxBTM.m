function [stats_full_avg, stats_approx_avg, stats_best_avg] = ...
                                       expWeightedApproxBTM( platonic_solid, ...
                                                             basis, ...
                                                             signal_file, ...
                                                             level, ...
                                                             num_samples, ...
                                                    coeffs_retained_signal, ...
                                                             result_path )
%
% [stats_full_avg, stats_approx_avg, stats_full , stats_approx] = 
%                                  expWeightedApproxBTM( platonic_solid, ...
%                                                        basis, ...
%                                                        signal_file, ...
%                                                        level, ...
%                                                        num_samples, ...
%                                                        thresholds, ...
%                                                        result_path )
%
% Validate the rotation for spherical wavelets by computing the rotation
% matrices for \a num_samples different rotations and computing some
% statistical data
%
% @return  stats_full_avg  average sparsity and L1 and L2 error for the
%                          rotation with the full BTM (without
%                          approximation)
% @return  stats_approx_avg  average sparsity and L1 and L2 error for
%                                the rotation with the approximated BTM
% @return  stats_full  sparsity and L1 and L2 error for the individual
%                      rotations with the full BTM employed to compute the
%                      average data
% @return  stats_approx  sparsity and L1 and L2 error for the individual
%                        rotations with the approximated BTM employed to 
%                        compute the average data
% @param  platonic_solid  platonic solid which is employed to derive the
%                         partition over which the basis is defined
% @param  basis  {'osh', 'bioh', 'pwh'} spherical Haar wavelet basis to
%                employ for the experiments
% @param  signal_file  name + path of the file containing the spherical map
%                      which is used for the experiment
% @param  num_samples  number of sampled (random rotations) to employ for
%                      the experiment
% @param  coeffs_retained_signal  number of basis function coefficients
%                                 retained in the approximation of the
%                                 signal in the basis
% @param result_path  path where to store the result (the file name is
%                     generated from the input parameters), if no or an
%                     empty string is provided then no result is stored

  % initalize random number generator
  rand('state',sum(100*clock));  
  
  rp = [];
  if( nargin > 6)
    rp = result_path;
  end
  result_path = rp;

  
  % get necessary function handles for basis
  fhs = getFunctionHandlesBasis( basis);

  forest = getForestPlatonicSolid( platonic_solid, level, ...
                                   fhs.enforce_equal_area);

  % get signal and sample onto the partition on the finest level
  signal = imread( signal_file);
  forest_sampled = sampleSphericalMap( forest, signal, 10, level, 0);

  
  % statistics
  
  stats_full.err_l1 = [];
  stats_full.err_l2 = [];
  stats_full.sparsity = [];
  
  stats_best_approx.err_l1 = [];
  stats_best_approx.err_l2 = [];
  stats_best_approx.sparsity = [];
  
  stats_approx.err_l1 = [];
  stats_approx.err_l2 = [];
  stats_approx.sparsity = [];
 
  
  for i = 1 : num_samples;

    % generate random axis
    axis = rand(3,1);
    % rescale so that between the values are between -1 and 1
    axis = (axis - 0.5) * 2.0;
    axis = axis / norm(axis);

    % generate angle
    angle = rand * 360;

    disp( sprintf( 'axis = %f  %f  %f', axis(1), axis(2), axis(3)));
    disp( sprintf( 'angle = %f', angle)); 

    % setup rotation matrix
    R = getRotationMatrix( axis, angle);

    % rotate map
    forest_rotated = rotateForest( forest_sampled, R);
    
    % perform analysis on rotated signal and extract coefficient
    forest_ra = dswtAnalyseFull( forest_rotated, level, ...
                                 fhs.filters_analysis, fhs.normalize);
    
    % compute the threshold so that only the k largest coefficients are taken
    % into account in the next processing steps
    thresholds = getThresholdLargestK( forest_ra, level, ...
                                       coeffs_retained_signal, fhs.approx );

    % set coefficients below the threshold to 0
    forest_approx = approxSWT( forest_ra, level, thresholds, fhs.approx);

    coeffs_rotated = getCoeffsForest( forest_approx, level);
    

    % create matrix of coupling coefficients
    btm = computeCouplingCoeffs( forest_rotated, forest, level, level, basis); 
    
    % full btm
    
    % apply basis transformation
    coeffs_btm = btm * coeffs_rotated';

    % set the coefficients and perform reconstruction
    forest_btm = setCoeffsForest( forest, level, coeffs_btm');
    forest_btm_synth = dswtSynthesiseFull( forest_btm, level, ...
                                            fhs.filters_synthesis, ...
                                            fhs.denormalize, ...
                                            0, 1);

    % compute the error
    err_full = dswtFindErrorReprojection( forest_rotated, forest_btm_synth, ...
                                          level, level, 10);

    c_stats_full = findStatisticsRotation( err_full, btm);
    stats_full = updateStatisticsCounterRotation( stats_full, c_stats_full);

    %%%%%%%%%%%%%%%%%%%%%%%%%%    
    % smart approximation
    
    % btm_weighted = btm .* repmat( mean(coeffs_rotated), size(btm,2), 1);    
    % btm_approx = approxBTM( btm, btm_weighted, coeffs_retained);
    btm_approx = smartApproxBTM( btm, level, coeffs_retained_signal);
    coeffs_btm_nnz = nnz( btm_approx);
    
    coeffs_btm = btm_approx * coeffs_rotated';

    % set the coefficients and perform reconstruction
    forest_btm = setCoeffsForest( forest, level, coeffs_btm');
    forest_btm_synth = dswtSynthesiseFull( forest_btm, level, ...
                                           fhs.filters_synthesis, ...
                                           fhs.denormalize, ...
                                           0, 1);

    % compute the error
    err_approx = dswtFindErrorReprojection( forest_rotated, ...
                                            forest_btm_synth,...
                                            level, level, 10);

    c_stats_approx = findStatisticsRotation( err_approx, btm_approx);
    stats_best_approx = updateStatisticsCounterRotation( stats_best_approx, c_stats_approx);    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%
    % approximation

    % compute approx matrix
    btm_approx = approxBTM( btm, btm, coeffs_rotated, coeffs_btm_nnz);

    coeffs_btm = btm_approx * coeffs_rotated';

    % limit number of coefficients again

    % sort coefficients
    coeffs_sorted = sort( abs( coeffs_btm), 2, 'descend' );

    % determine threshold (midpoint between k and k+1)
    thresholds =   (coeffs_sorted(coeffs_retained_signal,:) ...
                + coeffs_sorted(coeffs_retained_signal+1,:)) / 2;
    
    % do for all data channels
    for( i = 1 : size( coeffs_btm, 2))
      coeffs_btm( find( abs( coeffs_btm(:,i)) < thresholds(i)), i ) = 0;
    end
    
    % set the coefficients and perform reconstruction
    forest_btm = setCoeffsForest( forest, level, coeffs_btm');
    forest_btm_synth = dswtSynthesiseFull( forest_btm, level, ...
                                           fhs.filters_synthesis, ...
                                           fhs.denormalize, ...
                                           0, 1);

    % compute the error
    err_approx = dswtFindErrorReprojection( forest_rotated, ...
                                            forest_btm_synth,...
                                            level, level, 10);

    c_stats_approx = findStatisticsRotation( err_approx, btm_approx);
    stats_approx = updateStatisticsCounterRotation(stats_approx,c_stats_approx);    

  end

  stats_full_avg.err_l1 = sum( stats_full.err_l1) / num_samples;
  stats_full_avg.err_l2 = sum( stats_full.err_l2) / num_samples;
  stats_full_avg.sparsity = sum( stats_full.sparsity) / num_samples;

  stats_approx_avg.err_l1 = sum( stats_approx.err_l1) / num_samples;
  stats_approx_avg.err_l2 = sum( stats_approx.err_l2) / num_samples;
  stats_approx_avg.sparsity = sum( stats_approx.sparsity) / num_samples;
  
  stats_best_avg.err_l1 = sum( stats_best_approx.err_l1) / num_samples;
  stats_best_avg.err_l2 = sum( stats_best_approx.err_l2) / num_samples;
  stats_best_avg.sparsity = sum( stats_best_approx.sparsity) / num_samples;
  
  
  if( 0 ~= numel( result_path))
    
    [pathstr, signal_name, ext, versn] = fileparts( signal_file);
    result_file = [ result_path  filesep 'rotation_' basis '_' ...
                    platonic_solid '_' ...
                    signal_name '_l' num2str( level) '_s' num2str( num_samples)];
    save( result_file, 'stats_full_avg', 'stats_approx_avg',  ...
                       'stats_best_avg', ...
                       'stats_full', 'stats_approx', 'stats_best_approx' );
  end
  
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function btm_approx = approxBTM( btm, btm_threshold, coeffs, k)
%
% btm_approx = approxBTM( btm, btm_threshold, k)
% 
% Compute approximation for BTM which retains k coefficients
%
% @param  btm  btm 
% @param  btm_threshold  btm to use for the thresholding (which, for
%                        example, is a weighted version of btm)
% @param  k  number of coefficients to retain
  
  indices = find( mean(coeffs) == 0);
  btm_threshold( : , indices) = 0;

  % convert to vector and sort
  slist = sort( full( abs(btm_threshold(:))), 'descend');
  
  % determine threshold
  threshold = (slist( k) + slist( k-1)) / 2;
    
  % compute approx btm
  btm_approx = btm;
  
  btm_approx( find( abs(btm_threshold) < threshold)) = 0;
  
  disp( sprintf( 'nnz( btm_approx) / k = %i / %i', nnz( btm_approx), k));
  
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function btm_approx = smartApproxBTM( btm, level, coeffs_retained)
%
%

  ar = [1.0 0.25 0.125 0675  0.01];

  v = [1.0 1.0 1.0 1.0];

  % generate weight matrix
  for( i = 2 : level)
    v = [v  [ar(i) * ones( 1, 3 * 4^(i-1))]];
  end

  num_blocks = size( btm, 2) / numel( v);
  
  % btm_weighted = btm .* repmat( mean( coeffs), size(btm,1), 1);
  btm_weighted = btm .* repmat( v, size(btm,1), num_blocks);
  
  sum_btm_weighted = full( abs( sum( btm_weighted, 2)));
  
  % weighting by coefficients automatically discards rows where the
  % corresponding basis function coefficient is zero
  slist = sort( sum_btm_weighted, 'descend');
  threshold = (slist( coeffs_retained) + slist( coeffs_retained-1)) / 2;
                
  indices = find( sum_btm_weighted < threshold);
              
  btm_approx = btm;
  btm_approx( indices, :) = 0;
  
  disp( sprintf( 'nnz( btm_approx) / k = %i / %i', ...
        nnz( btm_approx), coeffs_retained));
  
end