function result = expBatchTestCompression( forest, basis, im, level, ...
                                           num_coeffs_retained, ... 
                                           test_perfect_reconstruction, ...
                                           visualize, ...
                                           file_name_approx, ...
                                           file_name_error, ...
                                           file_name_sampled, ...
                                           bioh_optimal )
%  
% result = expBatchTestCompression( forest, basis, im, level, ...
%                                   num_coeffs_retained, ... 
%                                   test_perfect_reconstruction, ...
%                                   visualize, ...
%                                   file_name_approx, ...
%                                   file_name_error, ...
%                                   file_name_sampled )
%
% Run a batch test to evaluate the compression / approximation performance 
% of a spherical wavelet basis.
%          
% @param  root nodes of a forest of wavelet trees
% @param  basis  {'osh', 'bioh', 'pwh'} name of the spherical wavelet basis
%                to employ for the experiments
% @param  im  file + path name of the signal to employ for the experiments
%             or signal as 2D spherical map 
% @param  level  level on which the signal is to be defined
% @param  num_coeffs_retained  list with the number of coefficients to
%                                 retain for the nonlinear approximation
% @param  test_perfect_reconstruction  {0,1} test the perfect
%                                      reconstruction property of the
%                                      basis during the experiment
% @param  visualize  visualize the singals
% @param  file_name_approx  name of the file where the approximated signal
%                           is stored (as VRML), requires visualize = 1
% @param  file_name_error  name of the file where the error signal
%                          is stored (as VRML), requires visualize = 1
% @param  file_name_sampled  name of the file where the sampled (not
%                            approximated) signal is stored (as VRML), 
%                            requires visualize = 1
% @param  bioh_optimal  (optional, default = 1) use optimal (1) or
%                       k-largest approximation (0) to compute
%                       approximations for the Bio-Haar basis

  result = [];

  % pre-process input args

  tpr = 0;
  if( nargin > 5)
    tpr = test_perfect_reconstruction;
  end
  test_perfect_reconstruction = tpr;
  
  v = 0;
  if( nargin > 6)
    v = visualize;
  end
  visualize = v;
  
  fns = '';
  if( nargin > 7)
    fns = file_name_approx;
  end
  file_name_approx = fns;
  
  fne = '';
  if( nargin > 8)
    fne = file_name_error;
  end
  file_name_error = fne;
  
  fns = '';
  if( nargin > 9)
    fns = file_name_sampled;
  end
  file_name_sampled = fns;
  
  bho = 1;
  if( nargin > 10)
    bho = bioh_optimal;
  end
  bioh_optimal = bho;
  
  % get necessary function handles for basis
  fhs = getFunctionHandlesBasis( basis, bioh_optimal);

  % read source (if string provided)
  if( isstr( im))
    im = imread( im);
  end
  
  % reample the signal (10 samples per domain, do not show the sample locations)
  forest_sampled = sampleSphericalMap( forest, im, 10, level, 0);

  % perform forward wavelet transform on signal
  forest_analysed = dswtAnalyseFull( forest_sampled, level, ...
                                     fhs.filters_analysis, fhs.normalize);
  if( 1 == test_perfect_reconstruction)
    forest_test = dswtSynthesiseFull( forest_analysed, level, ...
                                      fhs.filters_synthesis, fhs.denormalize, ...
                                      1, 1);
                                 
    if( 0 == num_coeffs_retained) 

      % store result                      
      result( end+1, :) = getError(lp_norm, forest_test, forest_sampled, level);
  
      return;
    end
                          
    clear forest_test;
  end

  % visualize sampled data if requested
  if( visualize > 0)
    % visualize sampled data
    plotDataFast( forest_sampled, level, file_name_sampled);
  end
  
  % do for all approximation rates
  for( k = 1 : numel( num_coeffs_retained))

    % compute the threshold so that only the k largest coefficients are taken
    % into account in the next processing steps
    thresholds = getThresholdLargestK( forest_analysed, level, ...
                                       num_coeffs_retained(k), fhs.approx );

    % set coefficients below the threshold to 0
    forest_approx = approxSWT( forest_analysed, level, thresholds, fhs.approx);

    % Perform reconstruction of approximated signal
    forest_synth = dswtSynthesiseFull( forest_approx, level, ...
                                       fhs.filters_synthesis, fhs.denormalize, ...
                                        0, 1);

    % error
    [err_l1, err_l2, diff_signal] = ...
      getError( forest_synth, forest_sampled, level);
    result( k, 1) = mean( err_l1);
    result( k, 2) = mean( err_l2);

    % validate number of non-zero coefficients
    q = 0;
    c = getCoeffsForest( forest_approx, level);
    q = numel( find( c ~= 0));
    if( (q / numel(err_l1)) ~= num_coeffs_retained(k))
      disp(sprintf( ['WARNING: Unexpected number of non-zero coefficients: ' ...
                    '%i (%i expected).'], int16(round(q / numel(err_l1))), ...
                    num_coeffs_retained(k) ));
    end
    
    % visualization / store files as VRML

    if( visualize > 0)

      % tree with error signal as data
      max_vals = max( abs( diff_signal'))';
      scaler = repmat( ([200; 200; 200] ./ max_vals), 1,size(diff_signal, 2));
      err_colors = scaler .* abs( diff_signal);
      forest_error = setSignal( forest, level, err_colors);
      clear scaler max_vals err_colors diff_signal;

      disp( sprintf( 'Visualizing ...'));

      % assemble full filename
      fname_synth_current = '';
      if( 0 ~= numel(file_name_approx))
        [pathstr, name, ext] = fileparts( file_name_approx);
        fname_synth_current = fullfile( pathstr, ...
          [name '_c' num2str(num_coeffs_retained(k)) ext]);
      end
      fname_error_current = '';
      if( 0 ~= numel(file_name_error))
        [pathstr, name, ext] = fileparts( file_name_error);
        fname_error_current = fullfile(pathstr, ...
          [name '_c' num2str(num_coeffs_retained(k)) ext]);
      end

      % visualize reconstruction 
      plotDataFast( forest_synth, level, fname_synth_current);
      % visualize error
      plotDataFast( forest_error, level, fname_error_current);

    end

  end  % for all elements of num_coeffs_retained
  
end
