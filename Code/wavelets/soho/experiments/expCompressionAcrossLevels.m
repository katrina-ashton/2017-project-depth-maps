function result = expCompressionAcrossLevels( platonic_solid, basis, ...
                                              signal_file, ...
                                              levels, percent_retain, ... 
                                              save_path, ...
                                              bioh_optimal )
%  
% result = expCompressionAcrossLevels( basis, im, 
%                                      num_coeffs_per_level, ... 
%                                      bioh_optimal )
%
% Run a batch test to evaluate the compression / approximation performance 
% of a spherical wavelet basis.
%          
% @param 


  % initalize random number generator
  rand('state',sum(100*clock));  

  % pre-process input args

  bho = 1;
  if( nargin > 6)
    bho = bioh_optimal;
  end
  bioh_optimal = bho;
  
  base_path = '';
  save_result = 0;
  if( nargin > 5)
    if( numel( save_path) > 0)
      save_result = 1;
      base_path = save_path;
    end
  end
  

  % get coefficients to retain for the different levels
  dummy = getForestPlatonicSolid( platonic_solid, 2, 9); 
%   num_coeffs_per_level = expCoeffsPerLevel( numel( dummy), levels, ...
%                                             percent_retain);
  num_coeffs_per_level = [2 3 4 5 6 7; 64, 128, 256, 512, 1024, 2048];
  
  % get necessary function handles for basis
  fhs = getFunctionHandlesBasis( basis, bioh_optimal);

  % read source 
  signal = imread( signal_file);
  
  for( k = 1 : size( num_coeffs_per_level, 2))
  
    level = num_coeffs_per_level(1,k);
    
    % create forest
    forest = getForestPlatonicSolid( platonic_solid, ...
                                     level, ...
                                     fhs.enforce_equal_area);
                                   
    % reample the signal (10 samples per domain, do not show the sample locations)
    forest_sampled = sampleSphericalMap( forest, signal, ...
                                         expSamplesPerLevel( level), ...
                                         level, 0);

    % perform forward wavelet transform on signal
    forest_analysed = dswtAnalyseFull( forest_sampled, level, ...
                                       fhs.filters_analysis, fhs.normalize);
                                     
    % compute the threshold so that only the k largest coefficients are taken
    % into account in the next processing steps
    thresholds = getThresholdLargestK( forest_analysed, level, ...
                                       num_coeffs_per_level(2,k), ...
                                       fhs.approx );

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
    if( (q / numel(err_l1)) ~= num_coeffs_per_level(2,k))
      disp(sprintf( ['WARNING: Unexpected number of non-zero coefficients: ' ...
                    '%i (%i expected).'], int16(round(q / numel(err_l1))), ...
                    num_coeffs_per_level(2,k) ));
    end

  end  % for all elements of num_coeffs_retained
  
  if( 1 == save_result)
    
    [pathstr, signal_name, ext] = fileparts(signal_file);
    pr = strrep( num2str( percent_retain), '.', '');
    
    file_name_base = [base_path filesep 'cal_' basis '_' platonic_solid '_' ...
                      signal_name ...
                      '_l' num2str( levels(1)) 't' num2str( levels(end)) ...
                      '_' pr ];
   
    v = genvarname( ['cal_' basis '_' platonic_solid '_' signal_name]);
    eval( [v '= result';]);
    
    save( file_name_base, v);
    
  end
  
end
