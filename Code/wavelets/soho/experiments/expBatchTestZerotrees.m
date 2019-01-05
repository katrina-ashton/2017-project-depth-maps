function res = expBatchTestZerotrees( platonic_solid, basis, level, ...
                                      signal_files )
%
% res = expBatchTestZerotrees( platonic_solid, basis, level, signal_files )
%
% Perform batch to determine number of zerotrees
%
% @return  [n,k,2] number of zerotrees [:,:,1] vs. number of trees where
%                  the assumption has been violated [:,:,2] for the n test
%                  signals and the k different approximation ratios (which
%                  are determined given the level)
% @param platonic_solid  platonic solid from which the partition is derived
%                        over which the basis is defined
% @param basis  {'osh','bioh,'pwh'} basis to used for the experiment
% @param level  level on which the data is defined
% @param  signal_files  file names of spherical map(s) to employ for the
%                       experiment (optional)

  sf = { 'experiments/signals/world.jpg', ...
         'experiments/signals/lambertian.jpg', ...
         'experiments/signals/visibility.jpg'};
  if( nargin > 3)
    sf = signal_files;
  end
  signal_files = sf;
          
  % different approx ratios
  num_coeffs_retained = getCoeffsRetained( level);
            
  % function handles for basis
  fhs = getFunctionHandlesBasis( basis);
  
  % construct partitoin tree
  forest = getForestPlatonicSolid( platonic_solid, level, ...
                                   fhs.enforce_equal_area);  

  % allocate result
  res = zeros( numel( signal_files), numel( num_coeffs_retained), 2, level);
                                   
  for( s_index = 1 : numel( signal_files))
    
    signal = imread( signal_files{ s_index});
    forest_sampled = sampleSphericalMap( forest, signal, 10, level, 0);
    
    forest_analysed = dswtAnalyseFull( forest_sampled, level, ...
                                       fhs.filters_analysis, fhs.normalize);
                                     
    % do for all approximation rates
    for( k = 1 : numel( num_coeffs_retained))

      % compute the threshold so that only the k largest coefficients are taken
      % into account in the next processing steps
      thresholds = getThresholdLargestK( forest_analysed, level, ...
                                         num_coeffs_retained(k), fhs.approx );
                                       
      % average over channels
      threshold = mean( thresholds(:));
      
      disp( sprintf( 'threshold = %f', threshold));
      
      % find number of zerotrees
      [num_trees_zt , num_trees_nzt] = ...
        findZerotreesSep( forest_analysed, level, threshold, fhs);      
%         findZerotrees( forest_analysed, level, threshold, fhs);
                                   
      res( s_index, k, 1, :) = num_trees_zt;
      res( s_index, k, 2, :) = num_trees_nzt;
      
      % set coefficients below the threshold to 0
      forest_approx = approxSWT( forest_analysed, level, thresholds, fhs.approx);
       
      coeffs = getCoeffsForest( forest_approx, level);
      disp( sprintf( '%f / %i', (nnz( coeffs) / 3), num_coeffs_retained(k) ));
      
    end
    
  end
  
end