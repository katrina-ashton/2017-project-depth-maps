function res = expAnalyseCoeffVector( platonic_solid, basis, level, ...
                                      signal_file)
%
% res = expAnalyseCoeffVector( platonic_solid, basis, level, signal_file)
%
% Analyse the structure of the coefficient vector (without approximation),
% in particular the number of non-zero coefficients per level and the mean
% of magnitude of the coefficients per level
% 
% @return [2,level]  ratio of nnz vs. total number of coefficients for all 
%                    [1,:] levels and mean of the coefficients per level [2,:]
% @param  platonic_solid  platonic solid from which the partition is
%                         derived over which the basis is defined
% @param  basis  {'osh','bioh','pwh'} spherical Haar wavelet basis to use
%                for the experiment
% @param  level  level on which the data is defined
% @param  signal_file   file containing the spherical map which is used as
%                       signal for the experiment
 
  res = zeros( 2, level);

  % get function handles for basis
  fhs = getFunctionHandlesBasis( basis);

  forest = getForestPlatonicSolid( platonic_solid, level, fhs.enforce_equal_area);

  signal = imread( signal_file);
  forest_sampled = sampleSphericalMap( forest, signal, 10, level, 0);

  forest_analysed = dswtAnalyseFull( forest_sampled, level, ...
                                     fhs.filters_analysis, fhs.normalize);

  coeffs = getCoeffsForest( forest_analysed, level);

  num_coeffs_tree = size(coeffs,2) / numel(forest);

  % determine percentage of zero coefficients per level

  x_min = 1;
  x_max = 4;

  for( k = 1 : (level))

    avg = 0;
    num_nnz = 0;
    num_total = 0; 

    for( i = 0 : (numel( forest) - 1))

      c_coeffs = coeffs(:,(num_coeffs_tree * i) + 1 : (num_coeffs_tree * (i+1)));

      num_nnz = num_nnz + nnz( c_coeffs( : , x_min : x_max));
      num_total = num_total + numel( c_coeffs( :, x_min : x_max));

      avg = avg + mean( mean( abs( c_coeffs( :, x_min : x_max))));

    end

    res(:,k) = [num_nnz / num_total , avg  / (numel( forest) * 3) ];
    
    x_min = x_max + 1;
    x_max = x_max + (3 * 4^k);

  end

end