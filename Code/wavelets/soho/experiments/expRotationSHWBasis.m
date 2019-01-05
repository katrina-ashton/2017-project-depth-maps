function [stats_full_avg, stats_approx_avg, stats_full , stats_approx] = ...
                                       expRotationSHWBasis( platonic_solid, ...
                                                            basis, ...
                                                            signal_file, ...
                                                            level, ...
                                                            num_samples, ...
                                                            thresholds, ...
                                                            result_path )
%
% [stats_full_avg, stats_approx_avg, stats_full , stats_approx] = 
%                                      expRotationSHWBasis( platonic_solid, ...
%                                                           basis, ...
%                                                           signal_file, ...
%                                                           level, ...
%                                                           num_samples, ...
%                                                           thresholds, ...
%                                                           result_path )
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
% @param  thresholds  (optional)  thresholds to use for the approximation of
%                      the BTM, if parameter is not specified or empty list
%                      is provided then no experiments with approximated
%                      BTMs are performed
% @param result_path  path where to store the result (the file name is
%                     generated from the input parameters), if no or an
%                     empty string is provided then no result is stored

  % initalize random number generator
  rand('state',sum(100*clock));  

  % pre-process optional input arguments
  
  ts = [];
  if( nargin > 5)
    ts = thresholds;
  end
  thresholds = ts;
  
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
  forest_sampled = sampleSphericalMap( forest, signal, ...
                                       expSamplesPerLevel( level), ...
                                       level, 0);

  % statistics
  
  stats_full.err_l1 = [];
  stats_full.err_l2 = [];
  stats_full.sparsity = [];
  
  % initialize stats for different approximation ratios
  stats_approx = [];
  stats_approx_avg = [];
  for( k = 1 : numel( thresholds))
    stats_approx(k).err_l1 = [];
    stats_approx(k).err_l2 = [];
    stats_approx(k).sparsity = [];
    
    stats_approx_avg(k).err_l1 = 0;
    stats_approx_avg(k).err_l2 = 0;    
    stats_approx_avg(k).sparsity = 0;    
  end  
  
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
    coeffs_rotated = getCoeffsForest( forest_ra, level);

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
    
    % approximation
    
    for( k = 1 : numel( thresholds))
      
      threshold = thresholds(k);
    
      % compute approx matrix
      ct = threshold * max( abs(btm(:)));
      btm_approx = btm;
      btm_approx( find( abs( btm_approx) < ct)) = 0.0;

      disp( sprintf( 'nnz( btm_approx) = %i', nnz( btm_approx) ));
      
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
      stats_approx(k) = updateStatisticsCounterRotation( stats_approx(k), ...
                                                 c_stats_approx);    

      disp( sprintf( 'approx :: error (l1 / l2) :: %f /  %f', ...
                   c_stats_approx.err_l1, c_stats_approx.err_l2));  
      disp(sprintf('approx :: sparsity = %f percent', c_stats_approx.sparsity));

    end

    % output current results
    
    disp( sprintf( 'full :: error (l1 / l2) :: %f /  %f', ...
                   c_stats_full.err_l1, c_stats_full.err_l2));  
    disp( sprintf( 'full :: sparsity = %f percent', c_stats_full.sparsity));
    
  end

  stats_full_avg.err_l1 = sum( stats_full.err_l1) / num_samples;
  stats_full_avg.err_l2 = sum( stats_full.err_l2) / num_samples;
  stats_full_avg.sparsity = sum( stats_full.sparsity) / num_samples;

  disp( sprintf( '\n'));
  disp( sprintf( 'Full :: Average Error (l1 / l2) :: %f / %f', ...
                 stats_full_avg.err_l1, stats_full_avg.err_l2));
  disp( sprintf( 'Full :: Average Sparsity = %f percent', ...
                 stats_full_avg.sparsity));  

  % average results for approximation
  for( k = 1 : numel( thresholds))
  
    stats_approx_avg(k).err_l1 = sum( stats_approx(k).err_l1) / num_samples;
    stats_approx_avg(k).err_l2 = sum( stats_approx(k).err_l2) / num_samples;
    stats_approx_avg(k).sparsity = ...
                                   sum( stats_approx(k).sparsity) / num_samples;

    disp( sprintf( '\n'));
    disp( sprintf( 'Approx %f:: Average Error (l1 / l2) :: %f / %f', ...
                   thresholds(k), stats_approx_avg(k).err_l1, ...
                   stats_approx_avg(k).err_l2));
    disp( sprintf( 'Approx %f:: Average Sparsity = %f percent', ...
                   thresholds(k), stats_approx_avg(k).sparsity));  
  end
  
  if( 0 ~= numel( result_path))
    
    [pathstr, signal_name, ext, versn] = fileparts( signal_file);
    result_file = [result_path  filesep 'rotation_' basis '_' platonic_solid '_' ...
                    signal_name '_l' num2str( level) '_s' num2str( num_samples)];
    save( result_file, 'stats_full_avg', 'stats_approx_avg', ...
                       'thresholds', ...
                       'stats_full', 'stats_approx');
  end
  
end
