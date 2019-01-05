function [stats_full_avg , stats_approx_avg, stats_full , stats_approx] = ...
                                          expRotationCMapBasis( signal_file, ...
                                                                level, ...
                                                                num_samples, ...
                                                                thresholds, ...
                                                                path_save )
%
% [stats_full_avg , stats_approx_avg, stats_full , stats_approx] = 
%  expRotationCMapBasis( signal_file, level, num_samples, thresholds,path_save)
%
% Validate the rotation for 2D Haar wavelets defined over the faces of a cubemap
% by computing the rotation matrices for \a num_samples different rotations
% and computing some statistical data
%
% @result  stats_full_avg  average L1 and L2 error, and sparsity for the
%                          rotation with the full (not approximated) BTM
% @result  stats_approx_avg  average L1 and L2 error, and sparsity for the
%                            rotation with approximated BTMs
% @result  stats_full  individual L1 and L2 error, and sparsity for the
%                      different samples for the rotation with the 
%                      full (not approximated) BTM
% @result  stats_approx  individual L1 and L2 error, and sparsity for the
%                        different samples for the rotation with the 
%                        approximated BTMs
% @param  signal_file  name + path of file containing the cross map which
%                      is employed as signal for the experiments
% @param  level   level on which the data is to be defined (if necessary,
%                 the cross map will be resampled)
% @param  num_samples  number of samples to take to compute the average
%                      data (number of randomly generated rotations)
% @param  thresholds  thresholds to use (w.r.t. the largest matrix element)
%                     for generating approximated BTMs, if no or an empty
%                     list is provided then no experiments will be
%                     performed with approximated BTMs
% @param path_save  path where to save the result, if not or empty string
%                   is provided then the result will not be saved

  rand('state',sum(100*clock));

  % pre-process optional input arguments
  ts = [];
  if( nargin > 3)
    ts = thresholds;
  end
  thresholds = ts;
  
  ps = '';
  if( nargin > 4)
    ps = path_save;
  end
  path_save = ps;
  
  % read image file and convert to internal representation for cubemaps
  signal = imread( signal_file);
  cmap = getFacesCubemapCross( signal);
  % scale image for given level
  scaler = (2^level) / (size( signal, 2) / 3);
  cmap_small = resizeCubemap( cmap, scaler);

  % perform analysis on the cubemap signal
  coeffs = haar2DAnalysisCubemap( cmap_small);

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
    
    stats_approx_avg(k).err_l1 = [];
    stats_approx_avg(k).err_l2 = [];
    stats_approx_avg(k).sparsity = [];    
  end

  for( i = 1 : num_samples)

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

    tic;

    % compute the basis transformation matrix
    btm = reprojectCubemapBasis( level, level, R);

    toc;

    % full btm
    
    % compute projection
    coeffs_rotated = btm * coeffs'; 
    cmap_synth = haar2DSynthesisCubemap( coeffs_rotated');  

    % compute error
    err_map = findErrorCubemap( cmap_small, cmap_synth, R);
    err_full = getLinearCoeffsCubemap( err_map);

    % get statistics
    c_stats_full = findStatisticsRotation( err_full, btm);
    stats_full = updateStatisticsCounterRotation( stats_full, c_stats_full);

    disp( sprintf( 'full :: error (l1 / l2) :: %f /  %f', ...
                   c_stats_full.err_l1, c_stats_full.err_l2));  
    disp( sprintf( 'full :: sparsity = %f percent', c_stats_full.sparsity));
    
    
    % approx btm
    
    for( k = 1 : numel( thresholds))
      
      threshold = thresholds(k);
    
      ct = threshold * max( abs(btm(:)));
      btm_approx = btm;
      btm_approx( find( abs( btm_approx) < ct)) = 0.0;

      coeffs_rotated = btm_approx * coeffs'; 
      cmap_synth = haar2DSynthesisCubemap( coeffs_rotated'); 

      % compute error
      err_map = findErrorCubemap( cmap_small, cmap_synth, R);
      err_approx = getLinearCoeffsCubemap( err_map);

      % get statistics
      c_stats_approx = findStatisticsRotation( err_approx, btm_approx);

      disp( sprintf( 'approx :: error (l1 / l2) :: %f /  %f', ...
                     c_stats_approx.err_l1, c_stats_approx.err_l2));  
      disp( sprintf( 'approx :: sparsity = %f percent', c_stats_approx.sparsity));

      % keep results of iteration
      stats_approx(k) = ...
        updateStatisticsCounterRotation( stats_approx(k), c_stats_approx);   

    end
      
  end

  stats_full_avg.err_l1 = sum( stats_full.err_l1) / num_samples;
  stats_full_avg.err_l2 = sum( stats_full.err_l2) / num_samples;
  stats_full_avg.sparsity = sum( stats_full.sparsity) / num_samples;
  
  disp( sprintf( '\n'));
  disp( sprintf( 'Full :: Average Error (l1 / l2) :: %f / %f', ...
                 stats_full_avg.err_l1, stats_full_avg.err_l2));
  disp( sprintf( 'Full :: Average Sparsity = %f percent', ...
                  stats_full_avg.sparsity));  
  
	for( k = 1 : numel( thresholds))
                  
    stats_approx_avg(k).err_l1 = sum( stats_approx(k).err_l1) / num_samples;
    stats_approx_avg(k).err_l2 = sum( stats_approx(k).err_l2) / num_samples;
    stats_approx_avg(k).sparsity = sum( stats_approx(k).sparsity) / num_samples;


    disp( sprintf( '\n'));
    disp( sprintf( 'Approx :: Average Error (l1 / l2) :: %f / %f', ...
                   stats_approx_avg(k).err_l1, stats_approx_avg(k).err_l2));
    disp( sprintf( 'Approx :: Average Sparsity = %f percent', ...
                    stats_approx_avg(k).sparsity));   

  end
        
   if( 0 ~= numel( path_save))
    
    [pathstr, signal_name, ext, versn] = fileparts( signal_file);
    result_file = [path_save  filesep 'rotation_cubemap_' ... 
                   signal_name '_l' num2str( level) ...
                   '_s' num2str( num_samples)];
    save( result_file, 'stats_full_avg', 'stats_approx_avg', ...
                       'thresholds', ...
                       'stats_full', 'stats_approx');
   end
  
end
